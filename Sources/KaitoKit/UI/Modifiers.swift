import SwiftUI

// MARK: - Stroke Background

/// ストローク背景ViewModifier
public struct StrokeBackground: ViewModifier {
    private let id = UUID()
    private var strokeSize: CGFloat
    private var strokeColor: Color

    public init(strokeSize: CGFloat, strokeColor: Color) {
        self.strokeSize = strokeSize
        self.strokeColor = strokeColor
    }

    public func body(content: Content) -> some View {
        if strokeSize > 0 {
            strokeBackgroundView(content: content)
        } else {
            content
        }
    }

    private func strokeBackgroundView(content: Content) -> some View {
        content
            .padding(strokeSize * 2)
            .background(strokeView(content: content))
    }

    private func strokeView(content: Content) -> some View {
        Rectangle()
            .foregroundColor(strokeColor)
            .mask(maskView(content: content))
    }

    private func maskView(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(resolvedView, at: .init(x: size.width / 2, y: size.height / 2))
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension View {
    /// ストローク効果を適用
    public func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeBackground(strokeSize: width, strokeColor: color))
    }
}

// MARK: - Image Extensions

#if canImport(UIKit)
import UIKit

extension UIImage {
    /// 画像にストロークを追加
    public func addStroke(color: UIColor, width: CGFloat) -> UIImage {
        let strokeRect = CGRect(
            x: 0,
            y: 0,
            width: size.width + width * 2,
            height: size.height + width * 2
        )

        UIGraphicsBeginImageContextWithOptions(strokeRect.size, false, scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return self }

        let imageRect = CGRect(x: width, y: width, width: size.width, height: size.height)

        let offsets: [(CGFloat, CGFloat)] = [
            (-width, -width), (0, -width), (width, -width),
            (-width, 0),                    (width, 0),
            (-width, width),  (0, width),   (width, width)
        ]

        context.setFillColor(color.cgColor)
        for (dx, dy) in offsets {
            let offsetRect = imageRect.offsetBy(dx: dx, dy: dy)
            context.saveGState()
            context.translateBy(x: offsetRect.minX, y: offsetRect.minY)
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -offsetRect.height)
            if let cgImage = self.cgImage {
                context.clip(to: CGRect(x: 0, y: 0, width: offsetRect.width, height: offsetRect.height), mask: cgImage)
                context.fill(CGRect(x: 0, y: 0, width: offsetRect.width, height: offsetRect.height))
            }
            context.restoreGState()
        }

        draw(in: imageRect)

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

extension Image {
    /// SwiftUI ImageをUIImageに変換
    public func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = UIColor.clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// MARK: - Animation Reader

fileprivate struct AnimationReaderModifier<Body: View>: AnimatableModifier {
    let content: (CGFloat) -> Body
    var animatableData: CGFloat

    init(value: CGFloat, @ViewBuilder content: @escaping (CGFloat) -> Body) {
        self.animatableData = value
        self.content = content
    }

    func body(content: Content) -> Body {
        self.content(animatableData)
    }
}

/// アニメーション値を読み取るためのビュー
public struct AnimationReader<Content: View>: View {
    let value: CGFloat
    let content: (_ animatingValue: CGFloat) -> Content

    public init(_ observedValue: Int, @ViewBuilder content: @escaping (_ animatingValue: Int) -> Content) {
        self.value = CGFloat(observedValue)
        self.content = { value in content(Int(value)) }
    }

    public init(_ observedValue: CGFloat, @ViewBuilder content: @escaping (_ animatingValue: CGFloat) -> Content) {
        self.value = observedValue
        self.content = content
    }

    public var body: some View {
        EmptyView()
            .modifier(AnimationReaderModifier(value: value, content: content))
    }
}

// MARK: - Share Sheet

/// 共有シート
public struct ShareSheet: UIViewControllerRepresentable {
    let photo: UIImage

    public init(photo: UIImage) {
        self.photo = photo
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems: [Any] = [photo, "シェア"]

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)

        return controller
    }

    public func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}
#endif
