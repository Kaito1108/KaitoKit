import Foundation

// MARK: - Date Extensions

extension Date {
    /// 今日の日付を「yyyy-MM-dd」形式で取得
    public var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }

    /// 週番号を「yyyy-Www」形式で取得
    public var weekString: String {
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfYear, from: self)
        let year = calendar.component(.yearForWeekOfYear, from: self)
        return String(format: "%d-W%02d", year, weekOfYear)
    }

    /// 日付を曜日（短縮形）で取得
    public var shortWeekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }

    /// 日付を「M/d」形式で取得
    public var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }

    /// 過去N日間の日付配列を取得
    ///
    /// - Parameter count: 日数
    /// - Returns: 日付配列（古い順）
    public static func pastDays(_ count: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        for i in (0..<count).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                dates.append(date)
            }
        }
        return dates
    }

    /// 過去N週間の週開始日配列を取得
    ///
    /// - Parameter count: 週数
    /// - Returns: 週開始日配列（古い順）
    public static func pastWeeks(_ count: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        for i in (0..<count).reversed() {
            if let date = calendar.date(byAdding: .weekOfYear, value: -i, to: Date()) {
                dates.append(date)
            }
        }
        return dates
    }
}
