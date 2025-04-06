import SwiftUI

// MARK: - Canvas View
/// The screen where interactive drawing (Supporter) or simulated trace viewing (Seeker) occurs.
struct CanvasView: View {

    // MARK: - Mode Definition
    /// Defines whether the canvas allows user drawing or displays a simulation.
    enum Mode {
        case guiding   // User can draw (Supporter role)
        case receiving // User sees simulated drawing (Seeker role)
    }

    // MARK: - Properties
    /// Specifies the behavior of the canvas based on the user's role.
    let mode: Mode
    /// Callback function triggered when the "End Session" button is tapped.
    let onEndSession: () -> Void

    // MARK: - State Variables (Guiding Mode)
    /// Stores the completed line strokes drawn by the user.
    @State private var lines: [[CGPoint]] = []
    /// Stores the points of the line currently being drawn via drag gesture.
    @State private var currentDragPoints: [CGPoint] = []

    // MARK: - State Variables (Receiving Mode)
    /// Stores the points of the simulated line as it animates.
    @State private var simulatedPoints: [CGPoint] = []
    /// The timer responsible for driving the animation sequence.
    @State private var animationTimer: Timer?
    /// Tracks the index of the next point to add from `simulatedPath`.
    @State private var currentPointIndex: Int = 0
    /// Holds the pre-defined sequence of points for the animation.
    private let simulatedPath = CanvasView.generateSimulatedPath()
    /// Shared color for both drawn and simulated traces.
    private let traceColor = Theme.primaryText

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // --- Main Drawing Canvas ---
                Canvas { context, size in
                    // --- Drawing logic based on mode ---
                    if mode == .guiding {
                        // Draw completed lines (Guiding)
                        for line in lines {
                            if line.count > 1 {
                                var path = Path()
                                path.addLines(line)
                                context.stroke(path, with: .color(traceColor), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                            }
                        }
                        // Draw active line (Guiding)
                        if currentDragPoints.count > 1 {
                            var currentPath = Path()
                            currentPath.addLines(currentDragPoints)
                            context.stroke(currentPath, with: .color(traceColor), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                        }
                    } else { // mode == .receiving
                        // Draw simulated line (Receiving)
                        if simulatedPoints.count > 1 {
                            var path = Path()
                            path.addLines(simulatedPoints)
                            context.stroke(path, with: .color(traceColor), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                        }
                    }
                } // End of Canvas view definition
                // --- Apply Gesture Conditionally to the Canvas ---
                .if(mode == .guiding) { canvasItself in // Apply to the Canvas view
                    canvasItself.gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { value in currentDragPoints.append(value.location) }
                            .onEnded { value in
                                if !currentDragPoints.isEmpty { lines.append(currentDragPoints) }
                                currentDragPoints = []
                            }
                    )
                }
                // --- Background ---
                // Apply background modifier *after* the canvas and conditional gesture
                .background(Theme.background)

                // --- Overlay UI Elements ---
                VStack {
                    Spacer()
                    Button("End Session") {
                        onEndSession()
                    }
                    .font(Theme.buttonFont)
                    .padding(.horizontal, Theme.standardPadding * 1.5)
                    .padding(.vertical, Theme.tightPadding)
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.endAction)
                    .controlSize(.regular)
                    .shadow(color: Theme.endAction.opacity(0.2), radius: 5, y: 3)
                    .padding(.bottom, 40)
                } // End VStack

            } // End ZStack
            .frame(width: geometry.size.width, height: geometry.size.height)
        } // End GeometryReader
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear { if mode == .receiving { startAnimation() } }
        .onDisappear { stopAnimation() }
    } // End of body

    // MARK: - Helper Methods (Animation & Path Generation)
    // ****** These methods MUST be INSIDE the CanvasView struct ******

    /// Starts the timer to animate the simulated path in receiving mode.
    private func startAnimation() {
        stopAnimation()
        simulatedPoints = []
        currentPointIndex = 0

        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            guard currentPointIndex < simulatedPath.count else {
                stopAnimation()
                return
            }
            simulatedPoints.append(simulatedPath[currentPointIndex])
            currentPointIndex += 1
        }
    }

    /// Stops the animation timer and releases it.
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    /// Generates a pre-defined array of points for the simulated animation path.
    /// - Returns: An array of `CGPoint` representing the path.
    static func generateSimulatedPath() -> [CGPoint] {
        var points: [CGPoint] = []
        let amplitude: CGFloat = 50.0
        let frequency: CGFloat = 0.02
        // Adjust Y offset based on visual testing in the target device/simulator
        let yOffset: CGFloat = UIScreen.main.bounds.height / 2.0 + 50 // Example: Center Y + offset
        let startX: CGFloat = 50.0
        let endX: CGFloat = UIScreen.main.bounds.width - 50.0
        let step: CGFloat = 5.0

        for x in stride(from: startX, through: endX, by: step) {
            let y = sin(x * frequency) * amplitude + yOffset
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }

} // ****** End of CanvasView struct ******


// MARK: - Conditional Modifier Helper
// Utility extension to apply modifiers conditionally in SwiftUI.
// ****** This extension should be OUTSIDE the CanvasView struct ******
extension View {
    /// Applies the given transform if the condition evaluates to `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview
// ****** Previews should be OUTSIDE the CanvasView struct ******
#Preview("Guiding Mode") {
    CanvasView(mode: .guiding, onEndSession: { print("Preview: End Session Tapped (Guiding)") })
}

#Preview("Receiving Mode") {
     CanvasView(mode: .receiving, onEndSession: { print("Preview: End Session Tapped (Receiving)") })
}
