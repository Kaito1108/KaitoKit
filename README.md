# KaitoKit

複数のSwiftプロジェクトで使用される共通UIコンポーネント、Firebase統合、認証、ユーティリティをまとめたSwift Packageです。

## 特徴

- 🎨 **UIコンポーネント**: ボタン、カラー、フォント、バナー通知など
- 🔥 **Firebase統合**: Firestore CRUD操作の簡易ラッパー
- 🔐 **認証ヘルパー**: メールバリデーション、パスワード強度チェック
- 🛠️ **便利なExtensions**: Date、Int、String、Viewの拡張機能

## インストール

### Swift Package Manager

`Package.swift`に以下を追加:

```swift
dependencies: [
    .package(url: "https://github.com/Kaito/KaitoKit.git", from: "1.0.0")
]
```

または、Xcodeで：
1. File > Add Package Dependencies...
2. URLに `https://github.com/Kaito/KaitoKit.git` を入力
3. バージョンを選択して追加

## 使い方

### UIコンポーネント

#### ボタン

```swift
import SwiftUI
import KaitoKit

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // プライマリボタン
            Button(action: { print("Tapped") }) {
                Buttons.primaryButton("タップ")
            }

            // 次へボタン
            Button(action: { print("Next") }) {
                Buttons.nextButton()
            }

            // バウンスアニメーション付きボタン
            Button("押す") {
                print("Bounced")
            }
            .buttonStyle(BouncyButtonStyle())
        }
    }
}
```

#### カラーシステム

```swift
import SwiftUI
import KaitoKit

struct ColorView: View {
    var body: some View {
        VStack {
            // HEX色を使用
            Text("Hello")
                .foregroundColor(Color(hex: "FF5733"))

            // HEX文字列を取得
            let color = Color.blue
            let hexString = color.hex  // "0000FF"

            // Codable対応（Colorをエンコード/デコード可能）
        }
    }
}
```

#### バナー通知

```swift
import SwiftUI
import KaitoKit

struct NotificationView: View {
    @State private var showBanner = false

    var body: some View {
        VStack {
            Button("成功通知を表示") {
                showBanner = true
            }

            if showBanner {
                BannerNotification(
                    showBanner: $showBanner,
                    bannerType: .success,
                    message: "成功しました！"
                )
                .padding()
            }
        }
    }
}
```

#### アニメーション付きビュー

```swift
import SwiftUI
import KaitoKit

struct AnimationView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            // カウントアップアニメーション
            AnimatedNumber(value: count)

            Button("カウント+10") {
                count += 10
            }
        }
    }
}
```

#### ハプティックフィードバック

```swift
import KaitoKit

// 成功フィードバック
Vibrations.success()

// エラーフィードバック
Vibrations.error()

// インパクトフィードバック
Vibrations.impact()
Vibrations.impactHeavy()
Vibrations.impactLight()
```

### カスタムフォント

#### 1. フォントファイルをプロジェクトに追加

1. `NotoSansJP-Bold.otf`などのフォントファイルをプロジェクトに追加
2. `Info.plist`に`Fonts provided by application`でフォント名を登録

例（Info.plist）:
```xml
<key>UIAppFonts</key>
<array>
    <string>NotoSansJP-Bold.otf</string>
    <string>NotoSansJP-Regular.otf</string>
</array>
```

#### 2. KaitoKitのフォントヘルパーを使用

```swift
import SwiftUI
import KaitoKit

struct FontView: View {
    var body: some View {
        VStack {
            Text("こんにちは")
                .font(CustomFonts.notoSansJPFont(.bold, size: 24))

            Text("Hello")
                .font(CustomFonts.notoSansJPFont(.regular, size: 18))

            // 他のカスタムフォントも使用可能
            Text("Custom")
                .font(CustomFonts.customFont("HelveticaNeue-Bold", size: 20))
        }
    }
}
```

### Firebase統合

#### 1. プロジェクトにFirebase SDKを追加

`Package.swift`に以下を追加:

```swift
dependencies: [
    .package(url: "https://github.com/Kaito/KaitoKit.git", from: "1.0.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            "KaitoKit",
            .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
        ]
    )
]
```

#### 2. FirestoreServiceを使用

```swift
import KaitoKit
import FirebaseFirestore

// データを作成
let userData = ["name": "Kaito", "age": 25, "email": "kaito@example.com"]
try await FirestoreService.shared.setData(
    collectionName: "users",
    documentName: "user123",
    data: userData
)

// データを取得
let name: String = try await FirestoreService.shared.fetchData(
    collectionName: "users",
    documentName: "user123",
    fieldName: "name"
)
print("Name: \(name)")

// データを更新
try await FirestoreService.shared.updateData(
    collectionName: "users",
    documentName: "user123",
    data: ["age": 26]
)

// ドキュメントを削除
try await FirestoreService.shared.deleteDocument(
    collectionName: "users",
    documentName: "user123"
)

// ドキュメントの存在確認
let exists = try await FirestoreService.shared.checkDocumentExists(
    collectionName: "users",
    documentName: "user123"
)
```

### 認証ヘルパー

```swift
import KaitoKit

// メールアドレスの検証
let email = "kaito@example.com"
if email.isValidEmail() {
    print("有効なメールアドレス")
}

// フォーム全体の検証
let isValid = FormValidator.isFormValid(email: email, password: "password123")
if isValid {
    print("フォームは有効")
}

// パスワード強度チェック
let strength = FormValidator.passwordStrength("MySecureP@ssw0rd")
switch strength {
case .weak:
    print("パスワードが弱いです")
case .medium:
    print("パスワードは中程度です")
case .strong:
    print("パスワードは強いです")
}
```

### Extensions

#### Date拡張

```swift
import Foundation
import KaitoKit

let date = Date()

// 様々な形式で日付を取得
print(date.dateString)        // "2026-02-21"
print(date.weekString)        // "2026-W08"
print(date.shortWeekday)      // "金"
print(date.shortDateString)   // "2/21"

// 過去N日間の日付配列
let pastDays = Date.pastDays(7)  // 過去7日分

// 過去N週間の日付配列
let pastWeeks = Date.pastWeeks(4)  // 過去4週分
```

#### Int拡張（時間フォーマット）

```swift
import KaitoKit

let minutes = 125

print(minutes.formattedStudyTime)       // "2時間5分"
print(minutes.formattedHours)           // "2.1時間"
print(minutes.formattedStudyTimeShort)  // "2h 5m"
```

#### String拡張

```swift
import KaitoKit

let longText = "これは非常に長いテキストです"
let limited = longText.limited(to: 10)  // "これは非常に長いテ"
```

#### View拡張

```swift
import SwiftUI
import KaitoKit

struct StyledView: View {
    var body: some View {
        VStack {
            // カードスタイル
            Text("カード")
                .padding()
                .cardStyle()

            // 黄色ボタンスタイル
            Button("ボタン") {
                print("Tapped")
            }
            .yellowButtonStyle()

            // セクションヘッダースタイル
            Text("セクション")
                .sectionHeaderStyle()
        }
    }
}
```

## 要件

- iOS 16.0+
- Swift 5.9+

## 注意事項

### カスタムフォント

カスタムフォント（NotoSansJPなど）のファイルは**含まれていません**。各プロジェクトでフォントファイルを追加し、Info.plistに登録してください。

### Firebase依存

FirestoreServiceを使用する場合は、プロジェクトでFirebase SDKを追加する必要があります。KaitoKit自体はFirebaseに依存していません。

## ライセンス

MIT License

## 作者

Kaito
