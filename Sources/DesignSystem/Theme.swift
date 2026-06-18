import SwiftUI

/// Solaris design system - warm, optimistic "premium lifestyle" palette.
/// Values mirror design/DESIGN.md (the Google Stitch source-of-truth).
enum Theme {
    enum Palette {
        static let surface = Color(hex: 0xFDF9F3)
        static let surfaceContainerLowest = Color(hex: 0xFFFFFF)
        static let surfaceContainerLow = Color(hex: 0xF7F3ED)
        static let surfaceContainer = Color(hex: 0xF1EDE7)
        static let surfaceContainerHigh = Color(hex: 0xEBE8E2)
        static let onSurface = Color(hex: 0x1C1C18)
        static let onSurfaceVariant = Color(hex: 0x514532)
        static let outline = Color(hex: 0x837560)
        static let outlineVariant = Color(hex: 0xD5C4AB)

        static let primary = Color(hex: 0x7C5800)          // deep gold (text accents)
        static let primaryContainer = Color(hex: 0xFFB800)  // sunny yellow
        static let onPrimaryContainer = Color(hex: 0x6B4C00)

        static let secondary = Color(hex: 0xA7391E)
        static let secondaryContainer = Color(hex: 0xFD7958) // soft orange

        static let tertiary = Color(hex: 0x15686C)          // deep teal (CTA)
        static let tertiaryContainer = Color(hex: 0x89D1D5)

        static let error = Color(hex: 0xBA1A1A)
        static let gradientStart = Color(hex: 0xFFB800)
        static let gradientEnd = Color(hex: 0xFD7958)
    }

    enum Radius {
        static let chip: CGFloat = 12
        static let button: CGFloat = 16
        static let card: CGFloat = 24
    }

    enum Space {
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let margin: CGFloat = 20
    }

    /// Sun-kissed ambient shadow (warm tint, soft + wide).
    static func cardShadow() -> some ViewModifier { CardShadow() }
}

private struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Theme.Palette.primaryContainer.opacity(0.10),
                       radius: 16, x: 0, y: 6)
    }
}

extension View {
    func cardShadow() -> some View { modifier(CardShadow()) }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

extension Font {
    static let display = Font.system(size: 32, weight: .heavy, design: .rounded)
    static let headlineLg = Font.system(size: 26, weight: .bold, design: .rounded)
    static let headlineMd = Font.system(size: 21, weight: .bold, design: .rounded)
    static let bodyLg = Font.system(size: 17, weight: .regular)
    static let bodyMd = Font.system(size: 15, weight: .regular)
    static let labelLg = Font.system(size: 13, weight: .semibold)
    static let callout = Font.system(size: 16, weight: .semibold)
}
