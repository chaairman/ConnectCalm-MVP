import SwiftUI

// MARK: - Canvas View (Placeholder)
// The screen where interaction (real or simulated) happens.
struct CanvasView: View {
    // Callback function to signal that the session should end
    let onEndSession: () -> Void

    var body: some View {
        ZStack {
            // Placeholder for the canvas background/drawing area
            Color.gray.opacity(0.1) // Very light gray background for now
                .ignoresSafeArea()

            VStack {
                Spacer() // Pushes content down
                Text("Canvas Area Placeholder")
                    .font(.title)
                    .foregroundColor(.secondary)
                Spacer() // Centers the text vertically

                // Button to end the session
                Button("End Session") {
                    onEndSession() // Call the callback function
                }
                .padding()
                // We'll style this button properly later (Phase 5)
                .buttonStyle(.borderedProminent) // Basic visible style for now
                .padding(.bottom, 40) // Add some space from the bottom edge
            }
        }
    }
}

// MARK: - Preview
#Preview {
    // Provide a dummy action for the preview
    CanvasView(onEndSession: { print("End Session Tapped in Preview") })
}
