import SwiftUI

// MARK: - Role Selection View
/// The initial screen presented to the user upon launching the app.
/// It allows the user to identify their current need or intention:
/// - Seeking immediate support during anxiety.
/// - Offering support to another user.
struct RoleSelectionView: View {

    // MARK: - Properties
    /// A callback closure that is executed when the "Seek Support" button is tapped.
    /// This should trigger the state transition to the seeker flow in the parent view (`ContentView`).
    let onSeekSupport: () -> Void

    /// A callback closure that is executed when the "Offer Support" button is tapped.
    /// This should trigger the state transition to the supporter flow in the parent view (`ContentView`).
    let onOfferSupport: () -> Void

    // MARK: - Body
    var body: some View {
        // Using NavigationView provides a container and potential structure for titles,
        // even if the navigation bar itself is hidden for a cleaner initial appearance.
        NavigationView {
            // VStack arranges the elements vertically.
            VStack(spacing: 30) { // `spacing` adds space between child elements (Title, Buttons).
                Spacer() // Pushes content towards the vertical center.

                // --- App Title ---
                Text("ConnectCalm")
                    .font(Theme.largeTitleFont) // Apply custom large title font from Theme.
                    .foregroundColor(Theme.primaryText) // Use standard primary text color from Theme.
                    .padding(.bottom, 50) // Add extra space below the title.

                // --- Seek Support Button (Primary Action) ---
                Button {
                    // Execute the passed-in closure when tapped.
                    onSeekSupport()
                } label: {
                    // The content displayed inside the button.
                    Text("Seek Support")
                        .font(Theme.buttonFont) // Use standard button font from Theme.
                        // Ensure sufficient contrast for text on the button's background.
                        // Using primaryText provides good contrast against the light primaryCalm background.
                        .foregroundColor(Theme.primaryText)
                        .frame(maxWidth: 250) // Give the button a consistent maximum width.
                        .padding() // Add internal padding around the text.
                }
                // Style the button to have a solid background color based on the tint.
                .buttonStyle(.borderedProminent)
                // Set the background color of the button using the primary theme color.
                .tint(Theme.primaryCalm)
                // Use a larger standard control size for easier tapping.
                .controlSize(.large)
                // Add a subtle shadow for depth, using the button's color.
                .shadow(color: Theme.primaryCalm.opacity(0.2), radius: 5, y: 3)

                // --- Offer Support Button (Secondary Action - Revised Style) ---
                Button {
                    // Execute the passed-in closure when tapped.
                    onOfferSupport()
                } label: {
                    Text("Offer Support")
                        .font(Theme.buttonFont) // Use standard button font.
                        // Ensure text contrasts well with the secondaryAccent background.
                        .foregroundColor(Theme.primaryText)
                        .frame(maxWidth: 250) // Match the width of the primary button.
                        .padding() // Add internal padding.
                }
                // Style changed to borderedProminent for better visibility against the background.
                .buttonStyle(.borderedProminent)
                // Use the secondary accent color for this button's background to differentiate it.
                .tint(Theme.secondaryAccent)
                .controlSize(.large) // Match control size.
                // Add a matching shadow using the secondary color.
                .shadow(color: Theme.secondaryAccent.opacity(0.2), radius: 5, y: 3)


                Spacer() // Pushes content towards the vertical center.
                Spacer() // Adds more space towards the bottom edge.
            }
            // Apply standard padding around the entire VStack content.
            .padding(Theme.standardPadding)
            // Ensure the VStack fills the entire available screen space.
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Set the background color for this view using the theme color.
            // `.ignoresSafeArea()` allows the background color to extend into the safe areas.
            .background(Theme.background.ignoresSafeArea())
            // Set a navigation title (useful if the bar were visible or for accessibility).
            .navigationTitle("Welcome")
            // Explicitly hide the navigation bar chrome for a cleaner look on this screen.
            .navigationBarHidden(true)
        }
        // Use the stack navigation view style for standard push/pop behavior if navigation were active.
        .navigationViewStyle(.stack)
    } // End of body
} // End of RoleSelectionView struct

// MARK: - Preview
/// Provides design-time previews in Xcode Canvas for the RoleSelectionView.
#Preview {
    RoleSelectionView(
        // Provide dummy closures for the preview functionality.
        onSeekSupport: { print("Preview: Seek Support Tapped") },
        onOfferSupport: { print("Preview: Offer Support Tapped") }
    )
    // Example of how to preview with different settings:
    // .environment(\.sizeCategory, .accessibilityExtraLarge) // Preview large text
    // .preferredColorScheme(.dark) // Preview dark mode
}
