import Foundation

// MARK: - String Extensions for Validation

extension String {
    /// メールアドレスの形式が正しいかチェック
    ///
    /// - Returns: 有効なメールアドレス形式の場合true
    public func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}

// MARK: - Form Validation Helper

/// フォームバリデーションヘルパー
public struct FormValidator {
    /// メールとパスワードの形式が有効かチェック
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    /// - Returns: 両方とも有効な場合true
    public static func isFormValid(email: String, password: String) -> Bool {
        guard email.isValidEmail(), password.count >= 8 else {
            return false
        }
        return true
    }

    /// パスワードの強度をチェック
    ///
    /// - Parameter password: パスワード
    /// - Returns: パスワード強度（weak, medium, strong）
    public static func passwordStrength(_ password: String) -> PasswordStrength {
        if password.count < 8 {
            return .weak
        }

        var strength = 0

        // 長さチェック
        if password.count >= 12 {
            strength += 1
        }

        // 数字を含むかチェック
        if password.range(of: "[0-9]", options: .regularExpression) != nil {
            strength += 1
        }

        // 大文字を含むかチェック
        if password.range(of: "[A-Z]", options: .regularExpression) != nil {
            strength += 1
        }

        // 小文字を含むかチェック
        if password.range(of: "[a-z]", options: .regularExpression) != nil {
            strength += 1
        }

        // 特殊文字を含むかチェック
        if password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil {
            strength += 1
        }

        switch strength {
        case 0...2:
            return .weak
        case 3...4:
            return .medium
        default:
            return .strong
        }
    }
}

/// パスワード強度
public enum PasswordStrength {
    case weak
    case medium
    case strong

    public var description: String {
        switch self {
        case .weak:
            return "弱い"
        case .medium:
            return "中程度"
        case .strong:
            return "強い"
        }
    }
}
