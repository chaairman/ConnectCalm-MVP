import SwiftUI

// MARK: - App State Definition
// Represents the current main view/state of the application.
enum AppState {
    case roleSelection // Initial screen with two choices
    case seekerLoading // Simulating connection for seeker
    case seekerCanvas  // Displaying canvas for seeker (shows simulated trace)
    case supporterLoading // Simulating finding someone for supporter
    case supporterCanvas // Displaying interactive canvas for supporter (allows drawing)
}

// MARK: - Content View
/// The main container view that manages the overall application state and transitions between primary views.
struct ContentView: View {
    // State variable to track and control the current visible view/flow
    @State private var currentState: AppState = .roleSelection

    var body: some View {
        // Use a VStack to manage layout and apply animations globally
        VStack {
            // Switch statement determines which view is currently displayed
            switch currentState {

            case .roleSelection:
                // Show the initial role selection screen
                RoleSelectionView(
                    // Action for the "Seek Support" button
                    onSeekSupport: { currentState = .seekerLoading }, // Transition to seeker loading state
                    // Action for the "Offer Support" button
                    onOfferSupport: { currentState = .supporterLoading } // Transition to supporter loading state
                )
                .transition(.opacity) // Use a fade transition for this view

            case .seekerLoading:
                // Show the loading view with the appropriate message for the seeker
                LoadingView(message: "Connecting...")
                    // Note: The .onChange block below handles the transition out of this state for now
                    .transition(.opacity)

            case .seekerCanvas:
                // Show the canvas view configured for the seeker (receiving mode)
                CanvasView(
                    mode: .receiving, // <-- Pass .receiving mode here
                    onEndSession: { currentState = .roleSelection } // Action for its "End Session" button
                )
                .transition(.opacity)

            case .supporterLoading:
                // Show the loading view with the appropriate message for the supporter
                LoadingView(message: "Looking for someone...")
                    // Note: The .onChange block below handles the transition out of this state for now
                    .transition(.opacity)

            case .supporterCanvas:
                 // Show the canvas view configured for the supporter (guiding mode)
                 CanvasView(
                    mode: .guiding, // <-- Pass .guiding mode here
                    onEndSession: { currentState = .roleSelection } // Action for its "End Session" button
                 )
                 .transition(.opacity)
            }
        }
        // Apply a default animation to transitions triggered by changes in `currentState`
        .animation(.easeInOut(duration: 0.3), value: currentState)

        // --- Temporary State Transition Logic (for Phase 1-3 Testing) ---
        // This .onChange handles the automatic transition from Loading -> Canvas
        // We will replace this with proper timed delays in Phase 4.
        .onChange(of: currentState) { newState in
             if newState == .seekerLoading {
                 // If we just entered seeker loading, schedule a quick jump to the canvas
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                     // Double-check state hasn't changed again (e.g., user navigated back)
                     if currentState == .seekerLoading {
                         currentState = .seekerCanvas
                     }
                 }
             } else if newState == .supporterLoading {
                // If we just entered supporter loading, schedule a quick jump to the canvas
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Double-check state
                     if currentState == .supporterLoading {
                        currentState = .supporterCanvas
                     }
                 }
             }
        }
    } // End of body
} // End of ContentView struct

// MARK: - Preview
#Preview {
    ContentView()
}
