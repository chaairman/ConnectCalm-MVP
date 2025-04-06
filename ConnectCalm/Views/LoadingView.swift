import SwiftUI

// MARK: - Loading View (Placeholder)
// Displays a simple message while simulating network activity.
struct LoadingView: View {
    let message: String // Message to display (e.g., "Connecting...", "Searching...")

    var body: some View {
        VStack {
            Text(message)
                .font(.title2)
                .foregroundColor(.secondary) // Use a less prominent color
            // We'll add a ProgressView or custom animation later (Phase 4/5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center it
        .background(Color(.systemBackground)) // Use system background for now
    }
}

// MARK: - Preview
#Preview("Connecting") {
    LoadingView(message: "Connecting...")
}

#Preview("Searching") {
    LoadingView(message: "Looking for someone...")
}
