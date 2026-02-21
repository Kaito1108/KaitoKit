#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - Screenshot Protection

/// UITextFieldを使ってスクリーンショット保護を実現するカスタムフィールド
class SecureField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isSecureTextEntry = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var secureContainer: UIView? {
        return self.subviews.first { subview in
            type(of: subview).description().contains("CanvasView")
        }
    }

    override var canBecomeFirstResponder: Bool { false }
    override func becomeFirstResponder() -> Bool { false }
}

/// SwiftUIで使いやすくするためのラッパー
public struct ScreenshotProtectedView<Content: View>: View {
    let content: Content
    let isProtectionEnabled: Bool

    public init(isProtectionEnabled: Bool = true, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.isProtectionEnabled = isProtectionEnabled
    }

    public var body: some View {
        if isProtectionEnabled {
            ProtectedContentWrapper(content: content)
        } else {
            content
        }
    }
}

/// UIKitベースの保護実装
struct ProtectedContentWrapper<Content: View>: UIViewControllerRepresentable {
    let content: Content

    func makeUIViewController(context: Context) -> ProtectedViewController<Content> {
        return ProtectedViewController(content: content)
    }

    func updateUIViewController(_ uiViewController: ProtectedViewController<Content>, context: Context) {
        uiViewController.updateContent(content)
    }
}

class ProtectedViewController<Content: View>: UIViewController {
    private var hostingController: UIHostingController<Content>
    private let secureField = SecureField()

    init(content: Content) {
        self.hostingController = UIHostingController(rootView: content)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        view.addSubview(secureField)
        secureField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secureField.topAnchor.constraint(equalTo: view.topAnchor),
            secureField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secureField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secureField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        guard let secureContainer = secureField.secureContainer else {
            return
        }

        addChild(hostingController)
        secureContainer.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: secureContainer.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: secureContainer.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: secureContainer.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: secureContainer.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

    func updateContent(_ content: Content) {
        hostingController.rootView = content
    }
}
#endif
