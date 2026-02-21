import Foundation

// MARK: - String Extensions

extension String {
    /// 文字数を制限
    ///
    /// - Parameter length: 最大文字数
    /// - Returns: 制限された文字列
    public func limited(to length: Int) -> String {
        if self.count <= length {
            return self
        }
        return String(self.prefix(length))
    }
}
