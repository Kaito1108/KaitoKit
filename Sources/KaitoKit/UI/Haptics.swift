#if canImport(UIKit)
import UIKit

/// ハプティックフィードバック
public struct Vibrations {
    /// 成功フィードバック
    public static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// エラーフィードバック
    public static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    /// 警告フィードバック
    public static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// 中程度のインパクトフィードバック
    public static func impact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// 強いインパクトフィードバック
    public static func impactHeavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    /// 軽いインパクトフィードバック
    public static func impactLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
#endif
