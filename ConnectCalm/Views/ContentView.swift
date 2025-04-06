import SwiftUI

// MARK: - App State Definition
/// Represents the different primary states or views the application can be in.
enum AppState {
    /// The initial screen where the user chooses their role.
    case roleSelection
    /// The loading state shown after the user taps "Seek Support". Simulates finding a supporter.
    case seekerLoading
    /// The canvas state for the "Seeker", displaying the simulated trace animation.
    case seekerCanvas
    /// The loading state shown after the user taps "Offer Support". Simulates searching for someone needing support.
    case supporterLoading
    /// The canvas state for the "Supporter", allowing them to draw interactively.
    case supporterCanvas
}

// MARK: - Content View
/// The root view of the application, responsible for managing the overall UI flow
/// by switching between different child views based on the `currentState`.
struct ContentView: View {

    // MARK: - State Variables
    /// Holds the current state of the application flow. Changes to this variable trigger UI updates.
    @State private var currentState: AppState = .roleSelection

    // MARK: - Simulation Timing Constants
    /// Defines the duration (in seconds) for the simulated loading period when seeking support.
    /// Adjust this value to change how long the "Connecting..." screen appears.
    private let seekerLoadingDuration: TimeInterval = 3.5 // seconds

    /// Defines the duration (in seconds) for the simulated loading period when offering support.
    /// Adjust this value to change how long the "Looking for someone..." screen appears.
    private let supporterLoadingDuration: TimeInterval = 1.5 // seconds

    // MARK: - Body Definition
    var body: some View {
        // Using a VStack as the container allows applying animations and transitions
        // consistently as the `currentState` changes which view is displayed inside the switch.
        VStack {
            // The `switch` statement is the core navigation logic for v1.
            // It determines which View struct to instantiate and display based on `currentState`.
            switch currentState {

            // MARK: Role Selection State
            case .roleSelection:
                RoleSelectionView(
                    // Pass a closure to be executed when the "Seek Support" button is tapped.
                    onSeekSupport: {
                        // Transition the app state to begin the seeker flow.
                        currentState = .seekerLoading
                    },
                    // Pass a closure for the "Offer Support" button.
                    onOfferSupport: {
                        // Transition the app state to begin the supporter flow.
                        currentState = .supporterLoading
                    }
                )
                // Apply a fade transition when this view appears/disappears.
                .transition(.opacity)

            // MARK: Seeker Loading State
            case .seekerLoading:
                LoadingView(message: "Connecting...")
                    // Modifier executed when this LoadingView appears on screen.
                    .onAppear {
                        // --- Start Simulated Delay ---
                        // Schedule code to run after `seekerLoadingDuration` seconds on the main thread.
                        DispatchQueue.main.asyncAfter(deadline: .now() + seekerLoadingDuration) {
                            // --- IMPORTANT State Check ---
                            // Before changing the state, verify that the app is *still* in the
                            // `.seekerLoading` state. This prevents incorrect transitions if the
                            // user somehow navigated away or the state changed due to another reason
                            // before the delay completed.
                            if currentState == .seekerLoading {
                                // If still loading, transition to the seeker's canvas view.
                                currentState = .seekerCanvas
                            }
                        }
                    }
                    .transition(.opacity)

            // MARK: Seeker Canvas State
            case .seekerCanvas:
                // Display the CanvasView configured for the Seeker role.
                CanvasView(
                    mode: .receiving, // Show simulated animation, disable drawing.
                    // Pass a closure for the "End Session" button inside CanvasView.
                    onEndSession: {
                        // Transition back to the initial role selection screen.
                        currentState = .roleSelection
                    }
                )
                .transition(.opacity)

            // MARK: Supporter Loading State
            case .supporterLoading:
                LoadingView(message: "Looking for someone...")
                     .onAppear {
                        // --- Start Simulated Delay ---
                        DispatchQueue.main.asyncAfter(deadline: .now() + supporterLoadingDuration) {
                            // --- IMPORTANT State Check ---
                            // Similar check as above, ensure we're still in the correct state.
                            if currentState == .supporterLoading {
                                // Transition to the supporter's canvas view.
                                currentState = .supporterCanvas
                            }
                        }
                    }
                    .transition(.opacity)

            // MARK: Supporter Canvas State
            case .supporterCanvas:
                 // Display the CanvasView configured for the Supporter role.
                 CanvasView(
                    mode: .guiding, // Enable drawing, disable simulated animation.
                    // Pass the closure for the "End Session" button.
                    onEndSession: {
                        // Transition back to the initial role selection screen.
                        currentState = .roleSelection
                    }
                 )
                 .transition(.opacity)
            } // End of switch statement
        } // End of VStack
        // Apply a standard animation to all state transitions within this ContentView.
        // This makes the view changes (driven by `currentState`) smoother.
        .animation(.easeInOut(duration: 0.3), value: currentState)
        // Note: The temporary `.onChange` block used for testing in Phase 3 has been removed.
        // The state transitions out of loading are now handled by the `.onAppear` + `asyncAfter`
        // logic within the `.seekerLoading` and `.supporterLoading` cases.

    } // End of body
} // End of ContentView struct

// MARK: - Preview
// Provides a preview of the ContentView in Xcode Canvas, starting from the initial state.
#Preview {
    ContentView()
}
