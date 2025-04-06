import SwiftUI

// MARK: - Canvas View
// The screen where interaction (real or simulated) happens.
struct CanvasView: View {

    // MARK: - Mode Definition
    // Defines whether the canvas allows user drawing or displays a simulation.
    enum Mode {
        case guiding   // User can draw (Supporter role)
        case receiving // User sees simulated drawing (Seeker role)
    }

    // MARK: - Properties
    /// Specifies the behavior of the canvas based on the user's role.
    let mode: Mode
    /// Callback function triggered when the "End Session" button is tapped.
    let onEndSession: () -> Void

    // MARK: - State Variables

    // --- State for Guiding Mode ---
    /// Stores the completed line strokes drawn by the user. Each inner array is one continuous line.
    @State private var lines: [[CGPoint]] = []
    /// Stores the points of the line currently being drawn via drag gesture.
    @State private var currentDragPoints: [CGPoint] = []

    // --- State for Receiving Mode ---
    /// Stores the points of the simulated line as it animates.
    @State private var simulatedPoints: [CGPoint] = []
    /// The timer responsible for driving the animation sequence.
    @State private var animationTimer: Timer?
    /// Tracks the index of the next point to add from `simulatedPath`.
    @State private var currentPointIndex: Int = 0
    /// Holds the pre-defined sequence of points that form the shape to be animated.
    /// Generated once by the static `generateSimulatedPath` function.
    private let simulatedPath = CanvasView.generateSimulatedPath()

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // --- Main Drawing Canvas ---
                Canvas { context, size in
                    // This closure is called whenever the view needs to redraw.

                    // --- Drawing logic based on mode ---
                    if mode == .guiding {
                        // --- Draw for Supporter (Guiding Mode) ---

                        // Draw all previously completed lines
                        for line in lines {
                            if line.count > 1 { // Need at least 2 points for a line segment
                                var path = Path()
                                path.addLines(line)
                                // Apply styling for completed lines
                                context.stroke(path,
                                               with: .color(.blue), // Use theme color later
                                               style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            }
                        }

                        // Draw the line currently being dragged (if any)
                        if currentDragPoints.count > 1 {
                            var currentPath = Path()
                            currentPath.addLines(currentDragPoints)
                            // Apply styling for the active drawing line (slightly different)
                            context.stroke(currentPath,
                                           with: .color(.blue.opacity(0.8)), // Slightly transparent or different?
                                           style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)) // Slightly thicker?
                        }

                    } else { // mode == .receiving
                        // --- Draw for Seeker (Receiving Mode) ---

                        // Draw the animated simulated line based on points added by the timer
                        if simulatedPoints.count > 1 {
                            var path = Path()
                            path.addLines(simulatedPoints)
                            // Apply styling for the simulated line (match supporter's style)
                            // Using purple temporarily for easy visual distinction during dev. Change to .blue later.
                            context.stroke(path,
                                           with: .color(.purple),
                                           style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        }
                    }
                } // End of Canvas view
                // --- Gestures (Applied Conditionally) ---
                // Only allow drawing gestures if in guiding mode
                .if(mode == .guiding) { view in
                    view.gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { value in
                                // Append the touched point to the current drag array
                                currentDragPoints.append(value.location)
                            }
                            .onEnded { value in
                                // When drag ends, if we have points, finalize the line
                                if !currentDragPoints.isEmpty {
                                    lines.append(currentDragPoints)
                                }
                                // Clear the temporary drag points for the next line
                                currentDragPoints = []
                            }
                    )
                }
                // --- Background ---
                .background(Color(.systemGray6)) // Set a background for the canvas area (refine in Phase 5)

                // --- Overlay UI Elements ---
                VStack {
                    Spacer() // Pushes the button to the bottom

                    Button("End Session") {
                        // Trigger the callback passed from the parent view
                        onEndSession()
                    }
                    .padding() // Add padding around the button text
                    .buttonStyle(.borderedProminent) // Basic visible style
                    .tint(.red) // Use a distinct color for ending action? (Or theme color)
                    .padding(.bottom, 40) // Add spacing from the bottom safe area edge
                }

            } // End of ZStack
            // Ensure the ZStack takes up all available space provided by GeometryReader
            .frame(width: geometry.size.width, height: geometry.size.height)

        } // End of GeometryReader
        .ignoresSafeArea() // Allow the canvas to extend into safe areas
        .navigationBarHidden(true) // Ensure the navigation bar stays hidden on this screen

        // --- Animation Lifecycle Management ---
        .onAppear {
            // When the view appears on screen...
            if mode == .receiving {
                // ...start the animation timer ONLY if in receiving mode.
                startAnimation()
            }
        }
        .onDisappear {
            // When the view disappears from screen...
            // ...always stop and clean up the timer to prevent memory leaks and background activity.
            stopAnimation()
        }
    } // End of body

    // MARK: - Helper Methods

    /// Starts the timer to animate the simulated path in receiving mode.
    private func startAnimation() {
        // Prevent starting multiple timers if called again accidentally
        stopAnimation()
        // Reset any previous animation state
        simulatedPoints = []
        currentPointIndex = 0

        // Schedule a timer that fires repeatedly
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            // Check if we have reached the end of the predefined path
            guard currentPointIndex < simulatedPath.count else {
                // All points added, stop the timer
                stopAnimation()
                return
            }

            // Add the next point from the path to the array that gets drawn
            simulatedPoints.append(simulatedPath[currentPointIndex])
            // Move to the next point index for the next timer fire
            currentPointIndex += 1
        }
    }

    /// Stops the animation timer and releases it.
    private func stopAnimation() {
        animationTimer?.invalidate() // Stop the timer from firing again
        animationTimer = nil // Release the timer object
    }

    /// Generates a pre-defined array of points for the simulated animation path.
    /// - Returns: An array of `CGPoint` representing the path.
    static func generateSimulatedPath() -> [CGPoint] {
        // This function defines the shape the Seeker will see.
        // You can customize this heavily to create different patterns.
        var points: [CGPoint] = []

        // --- Example: Simple horizontal wave ---
        // Adjust these parameters to change the wave's appearance
        let amplitude: CGFloat = 50.0     // How high/low the wave goes
        let frequency: CGFloat = 0.02     // How many waves fit horizontally (lower = wider)
        let yOffset: CGFloat = 300.0    // Vertical position on screen (adjust based on testing)
        let startX: CGFloat = 50.0      // Starting horizontal position
        let endX: CGFloat = 350.0       // Ending horizontal position (adjust for screen width)
        let step: CGFloat = 5.0         // How far apart points are (lower = smoother but more points)

        for x in stride(from: startX, through: endX, by: step) {
            let y = sin(x * frequency) * amplitude + yOffset // Basic Sine wave formula
            points.append(CGPoint(x: x, y: y))
        }

        // --- Example: Circle (replace wave logic if desired) ---
        /*
        let radius: CGFloat = 100.0
        let centerX: CGFloat = 200.0 // Adjust for screen center
        let centerY: CGFloat = 300.0 // Adjust for screen center
        let totalPoints = 100 // Number of points in the circle

        for i in 0...totalPoints {
            let angle = 2 * .pi * CGFloat(i) / CGFloat(totalPoints) // Angle in radians
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            points.append(CGPoint(x: x, y: y))
        }
        */

        return points
    }

} // End of CanvasView struct

// MARK: - Conditional Modifier Helper
// Utility extension to apply modifiers conditionally in SwiftUI.
extension View {
    /// Applies the given transform if the condition evaluates to `true`.
    /// Useful for conditionally applying gestures, effects, etc.
    /// - Parameters:
    ///   - condition: The boolean condition to evaluate.
    ///   - transform: The transformation function that takes the `View` and returns a modified `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview
// Provides previews for both modes in Xcode Canvas.
#Preview("Guiding Mode") {
    // Preview the canvas in the state where the user can draw.
    CanvasView(mode: .guiding, onEndSession: { print("Preview: End Session Tapped (Guiding)") })
}

#Preview("Receiving Mode") {
     // Preview the canvas in the state where it shows the animation.
     // The animation will start automatically in the preview.
     CanvasView(mode: .receiving, onEndSession: { print("Preview: End Session Tapped (Receiving)") })
}
