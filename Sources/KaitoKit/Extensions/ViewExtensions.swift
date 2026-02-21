import SwiftUI

// MARK: - View Modifiers

/// カードスタイルの修飾子
public struct CardModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(white: 1.0))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

/// 黄色ボタンスタイルの修飾子
public struct YellowButtonModifier: ViewModifier {
    public var isEnabled: Bool

    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }

    public func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(Color.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isEnabled ? Color.yellow : Color.gray.opacity(0.3))
            .cornerRadius(12)
    }
}

/// セクションヘッダースタイル
public struct SectionHeaderModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(Color.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - View Extension Methods

extension View {
    /// カードスタイルを適用
    public func cardStyle() -> some View {
        modifier(CardModifier())
    }

    /// 黄色ボタンスタイルを適用
    public func yellowButtonStyle(isEnabled: Bool = true) -> some View {
        modifier(YellowButtonModifier(isEnabled: isEnabled))
    }

    /// セクションヘッダースタイルを適用
    public func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderModifier())
    }
}
