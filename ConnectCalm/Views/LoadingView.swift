import SwiftUI

// MARK: - Loading View
// Displays a message and activity indicator while simulating network activity.
struct LoadingView: View {
    let message: String // Message to display (e.g., "Connecting...", "Searching...")

    var body: some View {
        VStack(spacing: 20) { // Add some spacing
            ProgressView() // Indeterminate progress indicator
                .scaleEffect(1.5) // Make it a bit larger

            Text(message)
                .font(.title3) // Slightly smaller font than before maybe
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6)) // Use a soft background consistent with others
        .navigationBarHidden(true) // Ensure nav bar stays hidden if pushed
    }
}

// MARK: - Preview
#Preview("Connecting") {
    LoadingView(message: "Connecting...")
}

#Preview("Searching") {
    LoadingView(message: "Looking for someone...")
}
