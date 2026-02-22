# KaitoKit

複数のSwiftプロジェクトで使用される共通UIコンポーネント、Firebase統合、認証、ユーティリティをまとめたSwift Packageです。

## 特徴

- 🎨 **UIコンポーネント**: ボタン、カラー、フォント、バナー通知など
- 🔥 **Firebase統合**: Firestore CRUD操作の簡易ラッパー
- 🔐 **Firebase認証**: Apple/Google/メールパスワードログイン、状態監視
- 🛡️ **認証ヘルパー**: メールバリデーション、パスワード強度チェック
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

### Firebase認証

#### 1. プロジェクトにFirebase Auth SDKを追加

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
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
        ]
    )
]
```

Googleログインを使う場合は、さらに以下も追加:

```swift
dependencies: [
    .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
        ]
    )
]
```

#### 2. FirebaseAuthServiceを使用

FirebaseAuthServiceは`ObservableObject`として実装されており、ユーザーの認証状態を自動的に監視します。

```swift
import SwiftUI
import KaitoKit
import FirebaseAuth

@main
struct YourApp: App {
    @StateObject private var authService = FirebaseAuthService.shared

    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
```

#### メールアドレス/パスワード認証

```swift
import KaitoKit

struct LoginView: View {
    @StateObject private var authService = FirebaseAuthService.shared
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("メールアドレス", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // サインアップ（返り値でユーザー情報を取得）
            Button("アカウント作成") {
                Task {
                    do {
                        let userInfo = try await authService.signUpWithEmail(email: email, password: password)
                        print("作成成功: UID=\(userInfo.uid), Email=\(userInfo.email ?? "なし")")
                    } catch {
                        print("エラー: \(error.localizedDescription)")
                    }
                }
            }

            // サインイン（返り値でユーザー情報を取得）
            Button("ログイン") {
                Task {
                    do {
                        let userInfo = try await authService.signInWithEmail(email: email, password: password)
                        print("ログイン成功: UID=\(userInfo.uid)")
                        print("メール: \(userInfo.email ?? "なし")")
                        print("表示名: \(userInfo.displayName ?? "なし")")
                        print("プロバイダー: \(userInfo.providerID ?? "なし")")
                    } catch {
                        print("エラー: \(error.localizedDescription)")
                    }
                }
            }
        }
        .padding()
    }
}
```

#### Apple Sign In

```swift
import SwiftUI
import KaitoKit
import AuthenticationServices

struct AppleSignInView: View {
    @StateObject private var authService = FirebaseAuthService.shared

    var body: some View {
        SignInWithAppleButton { request in
            let nonce = authService.prepareAppleSignIn()
            request.requestedScopes = [.fullName, .email]
            request.nonce = nonce
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                   let appleIDToken = appleIDCredential.identityToken,
                   let idTokenString = String(data: appleIDToken, encoding: .utf8),
                   let nonce = appleIDCredential.nonce {
                    Task {
                        do {
                            try await authService.signInWithApple(idToken: idTokenString, rawNonce: nonce)
                        } catch {
                            print("エラー: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Apple Sign In エラー: \(error)")
            }
        }
        .frame(height: 50)
    }
}
```

#### Googleログイン

```swift
import SwiftUI
import KaitoKit
import GoogleSignIn

struct GoogleSignInView: View {
    @StateObject private var authService = FirebaseAuthService.shared

    var body: some View {
        Button("Googleでログイン") {
            Task {
                do {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootViewController = windowScene.windows.first?.rootViewController else {
                        return
                    }
                    try await authService.signInWithGoogle(presentingViewController: rootViewController)
                } catch {
                    print("エラー: \(error.localizedDescription)")
                }
            }
        }
    }
}
```

#### サインアウト・アカウント削除

```swift
import KaitoKit

// サインアウト
Button("サインアウト") {
    do {
        try FirebaseAuthService.shared.signOut()
    } catch {
        print("エラー: \(error.localizedDescription)")
    }
}

// アカウント削除
Button("アカウント削除") {
    Task {
        do {
            try await FirebaseAuthService.shared.deleteAccount()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
}
```

#### パスワードリセット

```swift
import KaitoKit

Button("パスワードリセットメールを送信") {
    Task {
        do {
            try await FirebaseAuthService.shared.sendPasswordReset(email: "user@example.com")
            print("リセットメールを送信しました")
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
}
```

#### 現在のユーザー情報を取得

```swift
import KaitoKit

let authService = FirebaseAuthService.shared

// ログイン状態
if authService.isAuthenticated {
    print("ログイン中")
}

// ユーザー情報
if let userId = authService.userId {
    print("ユーザーID: \(userId)")
}

if let email = authService.userEmail {
    print("メール: \(email)")
}

if let name = authService.displayName {
    print("表示名: \(name)")
}

if let photoURL = authService.photoURL {
    print("プロフィール画像: \(photoURL)")
}
```

#### AuthUserInfo構造体

サインイン時に返される`AuthUserInfo`には以下の情報が含まれます：

```swift
public struct AuthUserInfo {
    public let uid: String                  // ユーザーID
    public let email: String?               // メールアドレス
    public let displayName: String?         // 表示名
    public let photoURL: URL?               // プロフィール画像URL
    public let isEmailVerified: Bool        // メール確認済みか
    public let creationDate: Date?          // アカウント作成日
    public let lastSignInDate: Date?        // 最終サインイン日
    public let providerID: String?          // プロバイダーID（"password", "google.com", "apple.com"等）
}
```

使用例：

```swift
// サインイン時に返り値としてユーザー情報を取得
let userInfo = try await authService.signInWithEmail(email: "user@example.com", password: "password")

// ユーザー情報を使用
print("UID: \(userInfo.uid)")
print("Email: \(userInfo.email ?? "未設定")")
print("表示名: \(userInfo.displayName ?? "未設定")")
print("メール確認済み: \(userInfo.isEmailVerified)")
print("アカウント作成日: \(userInfo.creationDate?.description ?? "不明")")
print("プロバイダー: \(userInfo.providerID ?? "不明")")

// Googleログインの場合も同様
let googleUserInfo = try await authService.signInWithGoogle()
print("Googleアカウント: \(googleUserInfo.email ?? "不明")")

// Appleログインの場合も同様
let appleUserInfo = try await authService.signInWithApple(idToken: token, rawNonce: nonce)
print("Apple ID: \(appleUserInfo.uid)")
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

FirestoreServiceやFirebaseAuthServiceを使用する場合は、プロジェクトでFirebase SDKを追加する必要があります。KaitoKit自体はFirebaseに依存していません（条件付きコンパイル使用）。

### Google Sign In依存

Googleログインを使用する場合は、GoogleSignIn-iOS SDKを追加する必要があります。KaitoKit自体はGoogleSignInに依存していません（条件付きコンパイル使用）。

## ライセンス

MIT License

## 作者

Kaito
