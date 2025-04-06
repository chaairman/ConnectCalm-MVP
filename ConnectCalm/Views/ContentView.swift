import SwiftUI

// MARK: - App State Definition
// Represents the current main view/state of the application.
enum AppState {
    case roleSelection // Initial screen with two choices
    case seekerLoading // Simulating connection for seeker
    case seekerCanvas  // Displaying canvas for seeker (will show simulated trace later)
    case supporterLoading // Simulating finding someone for supporter
    case supporterCanvas // Displaying interactive canvas for supporter (will allow drawing later)
}

// MARK: - Content View
struct ContentView: View {
    // State variable to track the current app flow
    @State private var currentState: AppState = .roleSelection

    var body: some View {
        // Use a switch statement to show the correct view based on the current state
        // Add a subtle animation for transitions
        VStack { // Use VStack to contain the switch for transitions
            switch currentState {
            case .roleSelection:
                RoleSelectionView(
                    onSeekSupport: { currentState = .seekerLoading }, // Change state
                    onOfferSupport: { currentState = .supporterLoading } // Change state
                )
                // Prevent default NavigationView transition, manage via state
                .transition(.opacity) // Fade transition

            case .seekerLoading:
                LoadingView(message: "Connecting...")
                    .onAppear {
                        // IMMEDIATE transition for Phase 1 testing - We'll add delay in Phase 4
                         currentState = .seekerCanvas
                    }
                    .transition(.opacity) // Fade transition

            case .seekerCanvas:
                CanvasView(onEndSession: { currentState = .roleSelection }) // Change state back
                    .transition(.opacity) // Fade transition

            case .supporterLoading:
                 LoadingView(message: "Looking for someone...")
                     .onAppear {
                         // IMMEDIATE transition for Phase 1 testing - We'll add delay in Phase 4
                         currentState = .supporterCanvas
                     }
                    .transition(.opacity) // Fade transition

            case .supporterCanvas:
                CanvasView(onEndSession: { currentState = .roleSelection }) // Change state back
                    .transition(.opacity) // Fade transition
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentState) // Animate changes based on state
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
