import Foundation
import SwiftUI

/// 基本カラー定義
public struct Colors {
    public static let text = Color.black
    public static let text2 = Color.black.opacity(0.5)
    public static let text3 = Color.black.opacity(0.2)
    public static let buttonColor = Color.black.opacity(0.8)
    public static let buttonColor2 = Color.black.opacity(0.4)
}

// MARK: - Color Extensions

extension Color {
    /// HEX文字列からColorを生成
    /// - Parameter hex: HEX文字列（例: "FF0000", "#FF0000", "F00"）
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#if canImport(UIKit)
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.components.red, forKey: .red)
        try container.encode(self.components.green, forKey: .green)
        try container.encode(self.components.blue, forKey: .blue)
        try container.encode(self.components.opacity, forKey: .opacity)
    }

    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        return (Double(components[0]), Double(components[1]), Double(components[2]), Double(components[3]))
    }

    /// ColorをHEX文字列に変換
    public var hex: String {
        let components = self.components
        let red = Int(components.red * 255)
        let green = Int(components.green * 255)
        let blue = Int(components.blue * 255)
        let alpha = Int(components.opacity * 255)

        if alpha == 255 {
            return String(format: "%02X%02X%02X", red, green, blue)
        } else {
            return String(format: "%02X%02X%02X%02X", alpha, red, green, blue)
        }
    }

    /// #付きのHEX文字列に変換
    public var hexWithHash: String {
        return "#" + hex
    }
}
#endif

#if canImport(UIKit)
import UIKit

extension UIColor {
    /// HEX文字列からUIColorを生成
    /// - Parameter hex: HEX文字列（例: "FF0000", "#FF0000"）
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
#endif
