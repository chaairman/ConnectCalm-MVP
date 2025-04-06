# Technical Implementation Plan: ConnectCalm v1.0

**Document Version:** 1.0
**Date:** May 16, 2024
**Based on:** PRD v1.0

---

## 1. Introduction

This document outlines the technical approach for building ConnectCalm v1.0 on iOS using Xcode 15.2 and SwiftUI. It follows the requirements specified in the PRD v1.0, emphasizing a phased approach suitable for solo development with simulation replacing real-time connectivity.

The primary goal is to create a functional prototype demonstrating the core user flows and the interactive canvas mechanic with a calming aesthetic, establishing a solid foundation for future development.

---

## 2. Core Technology Stack

*   **Language:** Swift 5.9+
*   **UI Framework:** SwiftUI
*   **Platform:** iOS 16.0+
*   **IDE:** Xcode 15.2
*   **Drawing:** SwiftUI `Canvas` API and `Path` for rendering traces.
*   **Gestures:** SwiftUI `DragGesture` for capturing user input on the canvas.
*   **State Management:** SwiftUI's built-in property wrappers (`@State`, `@StateObject`, potentially `@ObservedObject` if breaking down views significantly). Keep it simple initially.
*   **Navigation:** SwiftUI's `NavigationStack` or simple conditional view presentation based on state.
*   **Simulation:** `Timer` or `DispatchQueue.main.asyncAfter` for timed delays and simulated animations.
*   **Code Structure:** Organize code logically by feature or view type (e.g., Views, ViewModels (if used), Models, Utilities).

---

## 3. Overall Architecture (v1 - Simplified)

For v1, we'll adopt a relatively simple View-centric architecture leveraging SwiftUI's state management.

*   **`ConnectCalmApp.swift`:** The main app entry point. Sets up the initial view.
*   **`ContentView.swift`:** Acts as the main container, potentially managing the current app state (e.g., `showingRoleSelection`, `showingSeekerFlow`, `showingSupporterFlow`). Could host the `NavigationStack` if needed, or simply switch between major views.
*   **`RoleSelectionView.swift`:** Displays the "Seek Support" and "Offer Support" buttons. Triggers state changes in `ContentView` or navigates.
*   **`LoadingView.swift`:** A reusable view displaying a message and potentially a gentle animation (e.g., `ProgressView` styled). Accepts parameters for text (e.g., "Connecting...", "Searching...").
*   **`CanvasView.swift`:** The core interactive view. This will need internal state to manage:
    *   The mode (`guiding` or `receiving`).
    *   The points for the current trace (`[CGPoint]`) if `guiding`.
    *   The points for the simulated trace animation if `receiving`.
    *   Handles `DragGesture` for input in `guiding` mode.
    *   Uses `Canvas` to draw the background and traces.
    *   Contains the "End Session" button.
*   **(Optional) `Theme.swift`:** A struct or enum to define shared colors, fonts, padding values to ensure consistency.

---

## 4. Development Phases

### Phase 0: Project Setup & Basic Structure

*   **Goal:** Initialize the Xcode project and set up basic file organization.
*   **Tasks:**
    1.  Create a new Xcode project (App template, SwiftUI interface, Swift language).
    2.  Name it `ConnectCalm`.
    3.  Set the deployment target to iOS 16.0 or later.
    4.  Create basic folder groups (e.g., `Views`, `Utilities`, `Assets`).
    5.  Configure basic app settings (orientation lock to portrait if desired).
    6.  Add initial App Icon placeholder to Assets.
*   **Testing:**
    *   Project builds and runs successfully on the Simulator.
    *   Shows the default "Hello, World!" SwiftUI view.

### Phase 1: Role Selection & Basic Navigation Shell

*   **Goal:** Implement the main Role Selection screen and the basic navigation structure to switch between placeholder views for the different flows.
*   **Tasks:**
    1.  Modify `ContentView` to manage the main app state (e.g., enum `AppState { roleSelection, seekerLoading, seekerCanvas, supporterLoading, supporterCanvas }`).
    2.  Create `RoleSelectionView.swift`.
        *   Add two styled `Button`s ("Seek Support", "Offer Support").
        *   Style minimally for now (functionality first).
        *   Buttons should update the state in `ContentView` when tapped.
    3.  Create placeholder views for `LoadingView.swift` and `CanvasView.swift` (just display simple text indicating which view it is).
    4.  Implement the logic in `ContentView` to show the correct view based on the `AppState`.
*   **Testing:**
    *   App launches to `RoleSelectionView`.
    *   Tapping "Seek Support" transitions the view (momentarily) to the placeholder Loading view, then the placeholder Canvas view (we'll add delays later).
    *   Tapping "Offer Support" transitions the view (momentarily) to its placeholder Loading view, then its placeholder Canvas view.
    *   Ensure basic navigation flow works without crashes.

### Phase 2: Supporter Canvas - Drawing Implementation

*   **Goal:** Implement the interactive drawing functionality for the "Offer Support" flow.
*   **Tasks:**
    1.  Flesh out `CanvasView.swift`.
    2.  Add state variables (e.g., `@State private var currentPoints: [CGPoint] = []`, `@State private var completedLines: [[CGPoint]] = []` - optional, depends on how you want tracing to behave on lift-off). Focus on a single continuous line first (`currentPoints`).
    3.  Add a `DragGesture` to the main canvas area.
        *   On `.onChanged`, append the gesture's location to `currentPoints`.
        *   On `.onEnded`, potentially move `currentPoints` to `completedLines` and clear `currentPoints` (or just let the line persist).
    4.  Use the `Canvas` view within `CanvasView`.
        *   In the `draw` closure, iterate through `currentPoints` (and `completedLines` if used) and draw `Path` elements.
        *   Style the path (color, stroke width) with placeholder calming values.
    5.  Ensure `CanvasView` can be initialized or configured for the `guiding` mode.
*   **Testing:**
    *   Navigate to the Supporter flow's `CanvasView`.
    *   Drag finger on the screen.
    *   Verify that a line smoothly follows the finger's path.
    *   Verify the line styling is applied.
    *   Test edge cases (fast dragging, starting near edges).

### Phase 3: Seeker Canvas - Simulated Trace Animation

*   **Goal:** Implement the non-interactive canvas for the "Seek Support" flow, displaying a pre-defined animated trace.
*   **Tasks:**
    1.  Define a simple, pre-defined path (e.g., a slow circle or wave) as an array of `CGPoint` constants somewhere accessible.
    2.  Modify `CanvasView.swift` to handle the `receiving` mode.
    3.  Add state variables for the animation (e.g., `@State private var simulatedPoints: [CGPoint] = []`, `@State private var animationTimer: Timer?`, `@State private var pointIndex = 0`).
    4.  When `CanvasView` appears in `receiving` mode:
        *   Start a `Timer` that fires at a regular interval (e.g., every 0.05 seconds).
        *   On each timer fire, append the next point from the pre-defined path array to `simulatedPoints`.
        *   Stop the timer when all points are added.
        *   Invalidate the timer `onDisappear`.
    5.  Update the `Canvas` drawing logic: If in `receiving` mode, draw the path based on `simulatedPoints`. Use the same styling as the supporter's trace.
*   **Testing:**
    *   Navigate to the Seeker flow's `CanvasView`.
    *   Verify that the pre-defined shape animates smoothly onto the canvas over a few seconds.
    *   Ensure the animation stops correctly.
    *   Ensure the drawing uses the intended style.

### Phase 4: Simulation Logic & Flow Integration

*   **Goal:** Implement the timed delays for loading screens and connect the full user flows, including the "End Session" functionality.
*   **Tasks:**
    1.  Implement the actual `LoadingView.swift` with text and a simple `ProgressView` or custom animation.
    2.  Modify the navigation logic in `ContentView` (or wherever state is managed):
        *   When "Seek Support" is tapped, transition to `seekerLoading` state. Use `DispatchQueue.main.asyncAfter` or a one-shot `Timer` to wait 3-5 seconds, then transition to `seekerCanvas`.
        *   When "Offer Support" is tapped, transition to `supporterLoading` state. Use `asyncAfter` or `Timer` for 1-2 seconds, then transition to `supporterCanvas`.
    3.  Add the "End Session" `Button` to the `CanvasView`. Style it clearly but unobtrusively.
    4.  Connect the "End Session" button's action to reset the app state back to `roleSelection` (e.g., via a callback closure or binding passed to `CanvasView`). Ensure any timers in `CanvasView` are invalidated when ending the session.
*   **Testing:**
    *   Test the complete Seeker flow: Tap "Seek", see correct loading message for ~3-5s, see canvas with animation, tap "End", return to Role Selection.
    *   Test the complete Supporter flow: Tap "Offer", see correct loading message for ~1-2s, see interactive canvas, draw, tap "End", return to Role Selection.
    *   Verify timing delays feel appropriate.
    *   Verify ending the session cleans up state correctly (e.g., animation stops, trace clears for next time).

### Phase 5: Styling & Polish

*   **Goal:** Apply the final calming visual design and refine animations.
*   **Tasks:**
    1.  Define the final color palette (soft, muted colors) and add them to `Assets.xcassets`.
    2.  Choose a clean, legible font and apply it consistently. Consider adding it as a custom font if needed.
    3.  Implement the chosen background style (solid color, subtle gradient) for all views.
    4.  Refine the styling of buttons, text, and the trace effect (ensure it's soft/glowing as desired).
    5.  Refine loading indicators (make them gentle).
    6.  Add subtle screen transition animations (e.g., cross-dissolve or fade) if desired, ensuring they feel smooth and not jarring.
    7.  Review overall UI for clarity, simplicity, and calming feel.
*   **Testing:**
    *   Review all screens and flows on a device/simulator.
    *   Ensure consistent application of colors, fonts, and spacing.
    *   Verify animations are smooth and contribute to the calming vibe.
    *   Check contrast and legibility.

### Phase 6: Final Testing & Code Cleanup

*   **Goal:** Perform thorough testing of the complete v1 app and clean up the codebase.
*   **Tasks:**
    1.  Test both user flows extensively on the simulator and, if possible, a tethered device.
    2.  Look for any visual glitches, crashes, or unexpected behavior.
    3.  Review code for clarity, consistency, and comments. Add documentation where needed.
    4.  Remove any unused code or assets.
    5.  Run Xcode's Analyze tool to check for potential issues.
    6.  Ensure the app meets all requirements outlined in the PRD v1.0.
*   **Testing:**
    *   Execute User Flow A multiple times.
    *   Execute User Flow B multiple times.
    *   Check behavior when interrupting flows (e.g., backgrounding the app - though state isn't saved in v1, ensure it doesn't crash on resume).
    *   Final visual review.

---

## 5. Code Style & Conventions

*   Follow standard Swift API Design Guidelines.
*   Use meaningful names for variables, functions, and types.
*   Keep Views relatively small and focused; extract subviews where appropriate.
*   Add comments to explain complex logic or non-obvious decisions.
*   Use `// MARK: -` comments to organize code within files.
*   Format code consistently (Xcode's default formatting is a good start).

---

## 6. Future Considerations (v1 -> v2)

*   The current structure with distinct flows and a configurable `CanvasView` allows for easier integration of networking later.
*   The `CanvasView`'s drawing logic can be adapted to send/receive point data over a network connection.
*   State management might need refinement (e.g., introducing ViewModels, using `@EnvironmentObject`) when handling network states and shared session data.

---

This phased plan provides a clear path to building ConnectCalm v1. Remember to commit your code frequently (even locally without pushing to a remote repo) at the end of each significant task or phase! Good luck!