import SwiftUI

// MARK: - Role Selection View
// The initial view where the user chooses their role.
struct RoleSelectionView: View {
    // Callbacks for button actions
    let onSeekSupport: () -> Void
    let onOfferSupport: () -> Void

    var body: some View {
        NavigationView { // Add NavigationView for potential title, keeps structure clean
            VStack(spacing: 30) { // Add spacing between elements
                Spacer() // Push content towards the center

                Text("ConnectCalm")
                    .font(.largeTitle) // Or a custom font later
                    .fontWeight(.light) // Calming feel
                    .padding(.bottom, 50)

                // Button for Person A (Seeker)
                Button {
                    onSeekSupport() // Trigger the action passed from ContentView
                } label: {
                    Text("Seek Support")
                        .frame(maxWidth: 250) // Give buttons a consistent width
                }
                .buttonStyle(.borderedProminent) // Use a prominent style for main actions
                // Tint will be customized later for calming colors
                .tint(.blue) // Placeholder color

                // Button for Person B (Supporter)
                Button {
                    onOfferSupport() // Trigger the action passed from ContentView
                } label: {
                    Text("Offer Support")
                         .frame(maxWidth: 250) // Match width
                }
                .buttonStyle(.bordered) // Use a less prominent style for the secondary action (optional distinction)
                 .tint(.green) // Placeholder color

                Spacer() // Push content towards the center
                Spacer() // Add more space at the bottom
            }
            .padding() // Add padding around the VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make VStack fill the screen
            .background(Color(.systemGray6)) // Use a soft background color (will refine later)
            .navigationTitle("Welcome") // Set a title
            .navigationBarHidden(true) // Hide the navigation bar itself for a cleaner look initially
        }
        .navigationViewStyle(.stack) // Use stack style for standard behavior
    }
}

// MARK: - Preview
#Preview {
    RoleSelectionView(
        onSeekSupport: { print("Seek Support Tapped") },
        onOfferSupport: { print("Offer Support Tapped") }
    )
}
