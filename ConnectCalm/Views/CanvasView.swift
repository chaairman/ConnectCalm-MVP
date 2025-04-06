import SwiftUI

// MARK: - Canvas View (Placeholder)
// The screen where interaction (real or simulated) happens.
struct CanvasView: View {
    // Callback function to signal that the session should end
    let onEndSession: () -> Void
    
    // State variable to store the lines drawn by the user
    // Each inner array represents a single continuous line stroke
    @State private var lines: [[CGPoint]] = []
    // State variable to track the current drag operation
    @State private var currentDragPoints: [CGPoint] = []

    var body: some View {
            GeometryReader { geometry in // Use GeometryReader to get the available size
                ZStack {
                    // The main drawing canvas
                    Canvas { context, size in
                        // Drawing logic goes here
                        // Draw all completed lines
                        for line in lines {
                            if line.count > 1 { // Need at least 2 points to draw a line segment
                                var path = Path()
                                path.addLines(line)
                                context.stroke(path, with: .color(.blue), lineWidth: 5) // Placeholder style
                            }
                        }

                         // Draw the currently dragged line
                        if currentDragPoints.count > 1 {
                            var currentPath = Path()
                            currentPath.addLines(currentDragPoints)
                            // Use a slightly different visual cue for the active line (optional)
                            context.stroke(currentPath, with: .color(.blue.opacity(0.8)), lineWidth: 6)
                        }

                    }
                    // Apply the drag gesture to the canvas area
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local) // Use local coordinates
                            .onChanged { value in
                                // Append the current drag location to the temporary points array
                                currentDragPoints.append(value.location)
                            }
                            .onEnded { value in
                                 // Drag ended, finalize the current line
                                if !currentDragPoints.isEmpty {
                                    lines.append(currentDragPoints) // Add the finished line to our main array
                                }
                                 // Clear the temporary points for the next drag
                                currentDragPoints = []
                            }
                    )
                    .background(Color(.systemGray6)) // Set canvas background (will refine in Phase 5)

                    // Keep the End Session button overlaid
                    VStack {
                        Spacer() // Pushes button to the bottom

                        Button("End Session") {
                            onEndSession()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 40)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height) // Ensure ZStack fills GeometryReader
            }
            .ignoresSafeArea() // Allow canvas to extend to screen edges
            .navigationBarHidden(true) // Keep nav bar hidden
        }
    }

// MARK: - Preview
#Preview {
    // Provide a dummy action for the preview
    CanvasView(onEndSession: { print("End Session Tapped in Preview") })
}
