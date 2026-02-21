import SwiftUI

/// システムフォントプリセット
public struct Fonts {
    public static let title = Font.system(size: 60, weight: .semibold)
    public static let title2 = Font.system(size: 55, weight: .semibold)
    public static let title3 = Font.system(size: 50, weight: .semibold)
    public static let title4 = Font.system(size: 45, weight: .semibold)
    public static let title5 = Font.system(size: 40, weight: .semibold)
    public static let title6 = Font.system(size: 35, weight: .semibold)
    public static let title7 = Font.system(size: 30, weight: .semibold)
    public static let title8 = Font.system(size: 25, weight: .semibold)
    public static let title9 = Font.system(size: 20, weight: .semibold)
    public static let title10 = Font.system(size: 15, weight: .semibold)
    public static let title11 = Font.system(size: 10, weight: .semibold)
    public static let title12 = Font.system(size: 5, weight: .semibold)
}

/// カスタムフォントヘルパー
///
/// 使い方:
/// 1. プロジェクトにカスタムフォントファイル（例: NotoSansJP-Bold.otf）を追加
/// 2. Info.plistに"Fonts provided by application"でフォント名を登録
/// 3. CustomFonts.notoSansJPFont(.bold, size: 18) で使用
public struct CustomFonts {
    /// NotoSansJPフォントタイプ
    public enum NotoSansJP {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
        case thin
    }

    /// NotoSansJPフォントを取得
    /// - Parameters:
    ///   - type: フォントタイプ
    ///   - size: フォントサイズ
    /// - Returns: 指定されたカスタムフォント（フォントが見つからない場合はシステムフォント）
    public static func notoSansJPFont(_ type: NotoSansJP, size: CGFloat) -> Font {
        let fontName: String
        switch type {
        case .black:
            fontName = "NotoSansJP-Black"
        case .bold:
            fontName = "NotoSansJP-Bold"
        case .extraBold:
            fontName = "NotoSansJP-ExtraBold"
        case .extraLight:
            fontName = "NotoSansJP-ExtraLight"
        case .light:
            fontName = "NotoSansJP-Light"
        case .medium:
            fontName = "NotoSansJP-Medium"
        case .regular:
            fontName = "NotoSansJP-Regular"
        case .semiBold:
            fontName = "NotoSansJP-SemiBold"
        case .thin:
            fontName = "NotoSansJP-Thin"
        }
        return Font.custom(fontName, size: size)
    }

    /// 汎用カスタムフォント取得
    /// - Parameters:
    ///   - fontName: フォント名（例: "HelveticaNeue-Bold"）
    ///   - size: フォントサイズ
    /// - Returns: 指定されたカスタムフォント
    public static func customFont(_ fontName: String, size: CGFloat) -> Font {
        return Font.custom(fontName, size: size)
    }
}
