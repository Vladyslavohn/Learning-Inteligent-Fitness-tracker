import SwiftUI

/// LIFT Design System — quiet, dense dark interface.
enum LIFTTheme {

    // MARK: - Colors

    static let background = adaptive(light: 0xF2F2F7, dark: 0x0A0A0C)
    static let surface = adaptive(light: 0xFFFFFF, dark: 0x1C1C1E)
    /// Inner block surface.
    static let innerSurface = adaptive(light: 0xF2F2F7, dark: 0x202023)
    /// Thin 1px card stroke.
    static let cardStroke = adaptive(light: 0xD1D1D6, dark: 0x38383A)
    /// Primary text.
    static let textPrimary = adaptive(light: 0x1C1C1E, dark: 0xF5F5F7)
    static let textSecondary = adaptive(light: 0x636366, dark: 0xAEAEB2)
    static let textTertiary = adaptive(light: 0x8E8E93, dark: 0x8E8E93)
    static let controlTrack = adaptive(light: 0xD1D1D6, dark: 0x38383A)
    static let mutedSurface = adaptive(light: 0xE5E5EA, dark: 0x2C2C2E)

    // Accents — restrained, Apple-like two-accent system.
    /// Emerald — positive health metrics.
    static let emerald         = Color(hex: 0x34C759)
    /// Electric blue — AI intelligence elements.
    static let electricBlue    = Color(hex: 0x0A84FF)
    /// Orange — calories / energy.
    static let orange          = Color(hex: 0xFF9F0A)
    /// Pink — heart rate.
    static let pink            = Color(hex: 0xFF375F)
    /// Indigo — HRV / data.
    static let indigo          = Color(hex: 0x5E5CE6)
    /// Cyan — sleep.
    static let cyan            = Color(hex: 0x64D2FF)

    // MARK: - Metrics

    static let cardCornerRadius: CGFloat = 10
    static let cardPadding: CGFloat = 16
    static let screenPadding: CGFloat = 20

    private static func adaptive(light: UInt, dark: UInt) -> Color {
        Color(uiColor: UIColor { traits in
            let value = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((value >> 16) & 0xFF) / 255,
                green: CGFloat((value >> 8) & 0xFF) / 255,
                blue: CGFloat(value & 0xFF) / 255,
                alpha: 1
            )
        })
    }

}

// MARK: - Hex initializer

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
