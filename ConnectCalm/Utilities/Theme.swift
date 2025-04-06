import SwiftUI

// MARK: - App Theme
/// Defines the standard colors and fonts used throughout the ConnectCalm app
/// for a consistent and calming visual identity.
enum Theme {

    // MARK: - Colors
    // Defined in Assets.xcassets

    /// Primary background color for most views.
    static let background = Color("AppBackground")
    /// Primary calming color, used for main interactive elements, traces.
    static let primaryCalm = Color("PrimaryCalm")
    /// Secondary accent color, potentially for secondary buttons or highlights.
    static let secondaryAccent = Color("SecondaryAccent")
    /// Color used for actions like "End Session".
    static let endAction = Color("EndAction")
    /// Standard color for primary text labels.
    static let primaryText = Color("PrimaryText")
    /// Standard color for secondary or less important text labels.
    static let secondaryText = Color("SecondaryText")

    // MARK: - Fonts (Example - using system fonts with specific weights)

    static func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }

    static let largeTitleFont: Font = .system(size: 34, weight: .light)
    static let titleFont: Font = .system(size: 24, weight: .regular)
    static let bodyFont: Font = .system(size: 17, weight: .regular)
    static let buttonFont: Font = .system(size: 18, weight: .medium)
    static let captionFont: Font = .system(size: 14, weight: .light)

    // MARK: - Spacing (Optional - define standard padding)
    static let standardPadding: CGFloat = 16.0
    static let tightPadding: CGFloat = 8.0
}
