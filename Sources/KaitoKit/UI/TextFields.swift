import SwiftUI

/// テキストフィールドコンポーネント
public struct TextFields {
    /// プライマリテキストフィールドスタイル
    public struct PrimaryTextField: ViewModifier {
        public init() {}

        public func body(content: Content) -> some View {
            content
                .font(CustomFonts.notoSansJPFont(.bold, size: 18))
                .foregroundColor(Color(hex: "333333"))
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.black.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.5)
                )
                .cornerRadius(13)
        }
    }
}

extension View {
    /// プライマリテキストフィールドスタイルを適用
    public func primaryTextFieldStyle() -> some View {
        modifier(TextFields.PrimaryTextField())
    }
}
