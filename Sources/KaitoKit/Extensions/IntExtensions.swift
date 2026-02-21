import Foundation

// MARK: - Int Extensions (Time Formatting)

extension Int {
    /// 分数を「X時間Y分」形式にフォーマット
    public var formattedStudyTime: String {
        let hours = self / 60
        let minutes = self % 60
        if hours > 0 {
            return "\(hours)時間\(minutes)分"
        } else {
            return "\(minutes)分"
        }
    }

    /// 分数を「X時間」形式にフォーマット（小数点付き）
    public var formattedHours: String {
        let hours = Double(self) / 60.0
        return String(format: "%.1f時間", hours)
    }

    /// 分数を「Xh Ym」形式にフォーマット
    public var formattedStudyTimeShort: String {
        let hours = self / 60
        let minutes = self % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
