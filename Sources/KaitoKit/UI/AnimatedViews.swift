import SwiftUI

// MARK: - Animated Number

/// カウントアップアニメーション付きの数字表示
public struct AnimatedNumber: View {
    let value: Int
    let font: Font
    let color: Color

    @State private var displayValue: Double = 0

    public init(value: Int, font: Font = .largeTitle, color: Color = .primary) {
        self.value = value
        self.font = font
        self.color = color
    }

    public var body: some View {
        Text("\(Int(displayValue))")
            .font(font)
            .fontWeight(.bold)
            .foregroundColor(color)
            .onAppear {
                animateValue()
            }
            .onChange(of: value) { _, _ in
                animateValue()
            }
    }

    private func animateValue() {
        displayValue = 0
        withAnimation(.easeOut(duration: 1.0)) {
            displayValue = Double(value)
        }
    }
}

// MARK: - Loading View

/// ローディング表示
public struct LoadingView: View {
    public var message: String

    public init(message: String = "読み込み中...") {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                .scaleEffect(1.5)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error View

/// エラー表示とリトライボタン
public struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("エラーが発生しました")
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("再試行")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Empty State View

/// データがない時の表示
public struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    public init(icon: String, title: String, message: String) {
        self.icon = icon
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
