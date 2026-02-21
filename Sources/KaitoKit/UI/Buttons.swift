import SwiftUI

/// ボタンコンポーネント集
public struct Buttons {
    /// プライマリボタン
    public static func primaryButton(_ title: String) -> some View {
        VStack {
            Text(title)
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
    }

    /// 無効化されたプライマリボタン
    public static func primaryDisabledButton(_ title: String) -> some View {
        VStack {
            Text(title)
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
        .opacity(0.5)
    }

    /// 画像付きプライマリボタン
    public static func primaryImageButton(_ systemName: String) -> some View {
        VStack {
            Image(systemName: systemName)
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
    }

    /// 無効化された画像付きプライマリボタン
    public static func primaryDisabledImageButton(_ systemName: String) -> some View {
        VStack {
            Image(systemName: systemName)
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
        .opacity(0.5)
    }

    /// ローディング表示付きボタン
    public static func primaryLoadingButton() -> some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(10)
    }

    /// 次へボタン
    public static func nextButton() -> some View {
        VStack {
            Text("つぎへ")
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
    }

    /// 無効化された次へボタン
    public static func nextDisabledButton() -> some View {
        VStack {
            Text("つぎへ")
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .opacity(0.5)
    }

    /// 完了ボタン
    public static func completionButton() -> some View {
        VStack {
            Text("完了👍")
                .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                .foregroundColor(.black)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
    }
}

/// バウンスアニメーション付きボタンスタイル
public struct BouncyButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}
