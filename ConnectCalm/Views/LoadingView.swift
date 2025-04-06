import SwiftUI

// MARK: - Loading View
struct LoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Theme.primaryCalm) // Tint the spinner with theme color

            Text(message)
                .font(Theme.titleFont) // Use a suitable theme font
                .foregroundColor(Theme.secondaryText) // Use theme secondary text color
                .multilineTextAlignment(.center)
        }
        .padding(Theme.standardPadding * 2) // Add more padding
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea()) // Use theme background
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview("Connecting") {
    LoadingView(message: "Connecting...")
}

#Preview("Searching") {
    LoadingView(message: "Looking for someone...")
}
