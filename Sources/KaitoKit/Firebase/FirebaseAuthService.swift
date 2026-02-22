import Foundation
import SwiftUI

/// FirebaseAuthServiceを使用するには、プロジェクトにFirebase SDKを追加する必要があります。
///
/// Package.swiftに以下を追加:
/// ```swift
/// .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
/// ```
///
/// そして、ターゲットの依存関係に追加:
/// ```swift
/// .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
/// ```
///
/// Googleログインを使用する場合は、さらに以下も追加:
/// ```swift
/// .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0"),
/// .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
/// ```
///
/// コード内では:
/// ```swift
/// import KaitoKit
/// import FirebaseAuth
/// // Googleログインを使う場合
/// import GoogleSignIn
/// ```

#if canImport(FirebaseAuth)
import FirebaseAuth

#if canImport(AuthenticationServices)
import AuthenticationServices
#endif

#if canImport(CryptoKit)
import CryptoKit
#endif

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

// MARK: - Firebase Auth Errors

public enum FirebaseAuthError: Error, LocalizedError {
    case signInFailed
    case signUpFailed
    case signOutFailed
    case deleteAccountFailed
    case passwordResetFailed
    case invalidEmail
    case invalidPassword
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case appleSignInFailed
    case googleSignInFailed
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .signInFailed:
            return "ログインに失敗しました"
        case .signUpFailed:
            return "アカウント作成に失敗しました"
        case .signOutFailed:
            return "サインアウトに失敗しました"
        case .deleteAccountFailed:
            return "アカウント削除に失敗しました"
        case .passwordResetFailed:
            return "パスワードリセットに失敗しました"
        case .invalidEmail:
            return "メールアドレスが無効です"
        case .invalidPassword:
            return "パスワードが無効です"
        case .userNotFound:
            return "ユーザーが見つかりません"
        case .emailAlreadyInUse:
            return "このメールアドレスは既に使用されています"
        case .weakPassword:
            return "パスワードが弱すぎます"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .appleSignInFailed:
            return "Apple Sign Inに失敗しました"
        case .googleSignInFailed:
            return "Googleログインに失敗しました"
        case .unknown(let error):
            return "エラーが発生しました: \(error.localizedDescription)"
        }
    }
}

// MARK: - Firebase Auth Service

/// Firebase認証サービス（ObservableObject）
/// ユーザーの認証状態を自動的に監視し、SwiftUIビューに通知します
@MainActor
public class FirebaseAuthService: ObservableObject {
    public static let shared = FirebaseAuthService()

    /// 現在のユーザー
    @Published public private(set) var currentUser: User?

    /// ログイン状態
    @Published public private(set) var isAuthenticated: Bool = false

    /// ユーザーID
    public var userId: String? {
        currentUser?.uid
    }

    /// メールアドレス
    public var userEmail: String? {
        currentUser?.email
    }

    /// 表示名
    public var displayName: String? {
        currentUser?.displayName
    }

    /// プロフィール画像URL
    public var photoURL: URL? {
        currentUser?.photoURL
    }

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    #if canImport(CryptoKit)
    private var currentNonce: String?
    #endif

    private init() {
        setupAuthStateListener()
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Auth State Monitoring

    /// 認証状態の監視を開始
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    // MARK: - Email/Password Authentication

    /// メールアドレスとパスワードでサインアップ
    public func signUpWithEmail(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isAuthenticated = true
            }
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    /// メールアドレスとパスワードでサインイン
    public func signInWithEmail(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isAuthenticated = true
            }
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    /// パスワードリセットメールを送信
    public func sendPasswordReset(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    // MARK: - Apple Sign In

    #if canImport(AuthenticationServices) && canImport(CryptoKit)

    /// Apple Sign Inの準備（nonce生成）
    public func prepareAppleSignIn() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }

    /// Apple Sign Inで認証
    public func signInWithApple(idToken: String, rawNonce: String) async throws {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idToken,
            rawNonce: rawNonce
        )

        do {
            let result = try await Auth.auth().signIn(with: credential)
            await MainActor.run {
                self.currentUser = result.user
                self.isAuthenticated = true
            }
        } catch {
            throw FirebaseAuthError.appleSignInFailed
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    #endif

    // MARK: - Google Sign In

    #if canImport(GoogleSignIn)

    /// Googleログイン
    /// - Parameter presentingViewController: プレゼンテーション用のViewController（iOSの場合）
    public func signInWithGoogle(presentingViewController: UIViewController? = nil) async throws {
        guard let clientID = Auth.auth().app?.options.clientID else {
            throw FirebaseAuthError.googleSignInFailed
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        do {
            let result: GIDSignInResult

            #if os(iOS)
            guard let presentingVC = presentingViewController ?? UIApplication.shared.windows.first?.rootViewController else {
                throw FirebaseAuthError.googleSignInFailed
            }
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
            #else
            // macOSの場合
            guard let presentingWindow = NSApplication.shared.windows.first else {
                throw FirebaseAuthError.googleSignInFailed
            }
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingWindow)
            #endif

            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                throw FirebaseAuthError.googleSignInFailed
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            let authResult = try await Auth.auth().signIn(with: credential)
            await MainActor.run {
                self.currentUser = authResult.user
                self.isAuthenticated = true
            }
        } catch {
            throw FirebaseAuthError.googleSignInFailed
        }
    }

    #endif

    // MARK: - Sign Out

    /// サインアウト
    public func signOut() throws {
        do {
            try Auth.auth().signOut()

            #if canImport(GoogleSignIn)
            GIDSignIn.sharedInstance.signOut()
            #endif

            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            throw FirebaseAuthError.signOutFailed
        }
    }

    // MARK: - Delete Account

    /// アカウント削除
    public func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseAuthError.userNotFound
        }

        do {
            try await user.delete()
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
            }
        } catch {
            throw FirebaseAuthError.deleteAccountFailed
        }
    }

    // MARK: - Helper Methods

    /// FirebaseAuthのエラーをカスタムエラーにマッピング
    private func mapAuthError(_ error: NSError) -> FirebaseAuthError {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            return .unknown(error)
        }

        switch errorCode {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .invalidPassword
        case .userNotFound:
            return .userNotFound
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .networkError:
            return .networkError
        default:
            return .unknown(error)
        }
    }
}

#endif
