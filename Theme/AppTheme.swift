import SwiftUI
import Foundation

enum AppColor {
    // Primary brand colors
    static let primary = Color(hex: "#0A84FF")          // iOS blue
    static let primaryGreen = Color(hex: "#30D158")     // for products/товары
    static let accent = Color(hex: "#FF9F0A")           // orange accent
    
    // Backgrounds
    static let background = Color(.systemGroupedBackground)
    static let surface = Color(.secondarySystemGroupedBackground)
    static let surfaceElevated = Color(.tertiarySystemGroupedBackground)
    
    // Text
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    
    // Semantic
    static let success = Color(hex: "#30D158")
    static let warning = Color(hex: "#FF9F0A")
    static let destructive = Color(.systemRed)
    static let separator = Color(.separator)
    
    // Rating
    static let star = Color(hex: "#FF9F0A")
    
    // Badge/discount
    static let discountBg = Color(.systemRed).opacity(0.12)
    static let discountText = Color(.systemRed)
}

enum AppFont {
    static func largeTitle() -> Font { .largeTitle.bold() }
    static func title1() -> Font { .title.bold() }
    static func title2() -> Font { .title2.bold() }
    static func title3() -> Font { .title3.semibold() }
    static func headline() -> Font { .headline }
    static func body() -> Font { .body }
    static func callout() -> Font { .callout }
    static func subheadline() -> Font { .subheadline }
    static func footnote() -> Font { .footnote }
    static func caption() -> Font { .caption }
    static func caption2() -> Font { .caption2 }
}

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

enum AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let pill: CGFloat = 100
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Font Extension
extension Font {
    func semibold() -> Font {
        return self.weight(.semibold)
    }
}
