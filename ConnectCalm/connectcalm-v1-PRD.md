# Product Requirements Document: ConnectCalm v1.0

**Document Version:** 1.0
**Date:** May 16, 2024
**Author:** Gemini (acting as Senior App Developer) for [Your Name/Project]

---

## 1. Introduction

ConnectCalm is a mobile application designed to provide immediate, calming support to individuals experiencing anxiety or panic attacks. It aims to foster a sense of connection and grounding through a shared, interactive digital touch experience. When feeling overwhelmed, a user ("Seeker" - Person A) can signal their need for support. In future versions, another user ("Supporter" - Person B) would accept and guide the Seeker through a simple touch-based grounding exercise on a shared screen.

**This document outlines the requirements for Version 1.0 (v1), a foundational release focused on establishing the core user interface, demonstrating the primary user flows in a simulated environment, and capturing the app's intended calming aesthetic.** Due to development constraints (single developer, no Apple Developer Account), v1 will not feature real-time peer-to-peer connectivity. Instead, it will simulate the connection process and interaction to validate the concept and user experience.

---

## 2. Goals for v1.0

*   **Establish Core Concept:** Build the fundamental UI and navigation for both the "Seeker" and "Supporter" roles.
*   **Simulate Core Interaction:** Demonstrate the intended user experience of seeking, "connecting," and engaging with the interactive canvas, albeit without live data transfer between users.
*   **Create Calming Atmosphere:** Implement a UI/UX design characterized by soothing visuals, gentle animations, and intuitive interaction, reinforcing the app's purpose.
*   **Validate Interaction Mechanic:** Develop the canvas interface allowing a user (in the Supporter role) to trace patterns and visualize this input locally using simple effects (e.g., dot/line). Demonstrate how a Seeker *would* see this interaction.
*   **Technical Foundation:** Create a clean, well-structured codebase (likely SwiftUI) that can be extended with real networking capabilities in future versions.

---

## 3. Target Audience

*   **Primary:** Individuals aged 16+ who experience anxiety or panic attacks and are seeking immediate, non-verbal coping mechanisms.
*   **Secondary (Conceptual for v1):** Individuals willing to offer gentle, non-clinical support to others in distress.

---

## 4. Scientific Rationale & Grounding Principles

The core mechanic of ConnectCalm draws inspiration from established psychological principles for managing anxiety:

*   **Grounding Techniques:** Commonly used in Cognitive Behavioral Therapy (CBT) and Dialectical Behavior Therapy (DBT), grounding helps individuals anchor themselves in the present moment during dissociation or intense anxiety. Focusing on sensory input (like touch and sight) redirects attention away from overwhelming thoughts and emotions. The app digitizes this by focusing attention on a guided visual-tactile experience.
*   **Distraction:** Engaging in a simple, focused task like tracing a pattern provides a healthy distraction from the anxiety cycle.
*   **Human Connection & Co-regulation:** Anxiety can be incredibly isolating. Knowing that someone else is present (even simulated in v1) and guiding the grounding exercise can foster feelings of safety, care, and co-regulation, reducing the intensity of the panic response. The shared digital space aims to combat isolation.
*   **Mindfulness & Sensory Focus:** Following the traced pattern encourages mindfulness by requiring focus on the present visual and (implied) tactile input, interrupting racing thoughts.

While v1 lacks true connection, simulating the presence and guidance of another person taps into these principles by demonstrating the *intended* supportive interaction.

---

## 5. Features & Functionality (v1.0)

*   **5.1. Role Selection Screen (Main Screen):**
    *   Minimalist design upon app launch.
    *   Two clear, distinct buttons:
        *   "Seek Support" (for Person A flow)
        *   "Offer Support" (for Person B flow)
    *   Calm background and gentle UI elements.

*   **5.2. "Seek Support" Flow (Person A - Simulated):**
    *   **5.2.1. Initiate Request:** Tapping "Seek Support" transitions the user.
    *   **5.2.2. Simulated Connecting Screen:** Displays a calming loading/waiting animation or message (e.g., "Connecting...", "Finding support..."). This screen persists for a short, fixed duration (e.g., 3-5 seconds) to simulate the matching process.
    *   **5.2.3. Receiving Canvas Screen:** Transitions to the main interactive canvas view.
        *   Displays a clean, calming, blank canvas area.
        *   **Simulated Input:** After a brief pause, the app will automatically display a simple, pre-defined animation representing Person B's touch and trace (e.g., a soft dot appears and draws a simple shape like a slow circle or wave). This demonstrates *what Person A would see* in a real session. Person A does not interact with the trace in v1.
        *   **End Session Button:** A clearly visible but unobtrusive button to exit the canvas and return to the Main Screen.

*   **5.3. "Offer Support" Flow (Person B - Simulated Connection, Real Tracing):**
    *   **5.3.1. Initiate Offer:** Tapping "Offer Support" transitions the user.
    *   **5.3.2. Simulated Searching Screen:** Displays a brief message indicating searching (e.g., "Looking for someone to support..."). This persists for a very short, fixed duration (e.g., 1-2 seconds).
    *   **5.3.3. Guiding Canvas Screen:** Transitions to the main interactive canvas view.
        *   Displays the same clean, calming, blank canvas area.
        *   **Touch Input Enabled:** User can touch and drag their finger on the canvas.
        *   **Visual Feedback:** The app renders a simple visual representation of the user's touch path in real-time (e.g., a soft line or smooth glowing trail).
        *   **End Session Button:** A clearly visible but unobtrusive button to exit the canvas and return to the Main Screen.

*   **5.4. Interactive Canvas View:**
    *   **Shared Design:** The canvas background and general appearance are identical for both the "Receiving" and "Guiding" states.
    *   **Visual Style:** Minimalist, non-distracting background. Possibly a very subtle gradient or solid soft color.
    *   **Trace Effect (for Person B input):** A simple, smooth line or soft glowing effect that follows the user's finger. Color should be calming and have good contrast with the background.
    *   **Simulated Trace Effect (for Person A view):** A pre-programmed animation mimicking the simple trace effect (dot/line).
    *   **End Session Button:** Standard UI element, clearly labeled (e.g., "End Session", "Leave"). Tapping it provides confirmation (optional, maybe just directly returns to main screen for v1 simplicity) and navigates back to the Role Selection Screen.

---

## 6. User Flows (v1.0)

1.  **Flow A: Seeking Support (Simulated)**
    1.  User launches ConnectCalm -> Lands on Role Selection Screen.
    2.  User taps "Seek Support".
    3.  App displays "Connecting..." screen (simulated delay, ~3-5s).
    4.  App transitions to Receiving Canvas Screen.
    5.  App displays pre-defined trace animation (simple dot/line).
    6.  User observes the screen.
    7.  User taps "End Session".
    8.  App returns to Role Selection Screen.

2.  **Flow B: Offering Support (Simulated Connection)**
    1.  User launches ConnectCalm -> Lands on Role Selection Screen.
    2.  User taps "Offer Support".
    3.  App displays "Searching..." screen (simulated delay, ~1-2s).
    4.  App transitions to Guiding Canvas Screen.
    5.  User touches and drags finger on the canvas; simple trace appears.
    6.  User finishes tracing or decides to end.
    7.  User taps "End Session".
    8.  App returns to Role Selection Screen.

---

## 7. Design & UI/UX Considerations

*   **Aesthetic:** Calm, soothing, minimalist, safe.
*   **Color Palette:** Soft, desaturated colors (e.g., muted blues, greens, grays, potentially soft pastels). Avoid harsh or overly bright colors. Ensure good contrast for accessibility.
*   **Typography:** Clean, rounded, highly legible sans-serif fonts.
*   **Animations:** Use subtle, gentle transitions and effects (e.g., fades, soft pulses). Avoid jarring or fast movements. The trace effect itself should feel smooth and organic, like a simple line or soft dot.
*   **Sound:** Minimalist. Perhaps gentle confirmation sounds for button taps, but silence during the canvas interaction might be preferable to maintain focus. Avoid any potentially startling sounds.
*   **Simplicity:** Keep the UI extremely simple and intuitive. Users experiencing anxiety should not face cognitive friction navigating the app. One primary action per screen where possible.

---

## 8. Technical Considerations & Constraints

*   **Platform:** iOS 16.0+ (Leveraging modern SwiftUI features).
*   **Development Environment:** Xcode 15.2 on macOS.
*   **Language:** Swift.
*   **UI Framework:** SwiftUI preferred for declarative UI and ease of building clean interfaces.
*   **Drawing/Canvas:** SwiftUI's `Canvas` or `Path` combined with gesture recognizers (`DragGesture`) should suffice for v1's simple tracing requirements.
*   **Connectivity:** **NO network connectivity** will be implemented in v1. All "connection" flows are simulated locally with timed delays.
*   **Data Persistence:** No user data needs to be saved in v1. The app is stateless between sessions.
*   **No Developer Account:** Testing limited to iOS Simulator and tethered personal devices. No access to Push Notifications, TestFlight, or App Store distribution.

---

## 9. Future Considerations (Out of Scope for v1)

*   Real-time peer-to-peer connection (e.g., using WebSockets, CloudKit subscriptions, Firebase Realtime Database, or WebRTC).
*   Push Notifications for alerting potential Supporters ("Person B") when someone requests help.
*   User accounts/profiles (optional, could remain anonymous).
*   Basic matching logic (connecting a Seeker with an available Supporter).
*   More sophisticated visual effects for the trace.
*   Haptic feedback synchronized with the trace (for Person A).
*   Post-session feedback mechanism (e.g., rating the session's helpfulness).
*   Settings screen (e.g., customize visual themes, trace effects).
*   Soundscape options during the session.

---

## 10. Success Metrics (v1)

*   Successful implementation of both simulated user flows without crashes.
*   Positive qualitative feedback on the app's calming aesthetic and intuitive UI.
*   Clear demonstration of the core touch-tracing mechanic (simple line/dot) for the "Supporter" role.
*   Clear demonstration of how a "Seeker" would visually experience the support (simulated trace).
*   Codebase is clean, well-commented, and ready for future expansion.

---