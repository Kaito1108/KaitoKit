import SwiftUI

/// バナータイプ
public enum BannerType {
    case success
    case error
    case warning
    case loading
}

/// バナー通知ビュー
public struct BannerNotification: View {
    @Binding var showBanner: Bool
    @State var bannerType: BannerType
    var message: String

    public init(showBanner: Binding<Bool>, bannerType: BannerType, message: String) {
        self._showBanner = showBanner
        self.bannerType = bannerType
        self.message = message
    }

    public var body: some View {
        VStack {
            switch bannerType {
            case .success:
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)

                    Text(message)
                        .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 10)
                .background(Color(hex: "34F371"))
                .cornerRadius(50)

            case .error:
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)

                    Text(message)
                        .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 10)
                .background(Color(hex: "FF4949"))
                .cornerRadius(50)

            case .warning:
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                        .padding(.trailing, 10)

                    Text(message)
                        .font(CustomFonts.notoSansJPFont(.bold, size: 15))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 10)
                .background(Color(hex: "FFC800"))
                .cornerRadius(50)

            case .loading:
                HStack {
                    ProgressView()
                        .frame(width: 28, height: 28)
                        .tint(.white)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)

                    Text(message)
                        .font(CustomFonts.notoSansJPFont(.bold, size: 17))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                .padding(.vertical, 10)
                .background(Color(hex: "000000"))
                .cornerRadius(50)
            }
        }
        .onAppear {
            if bannerType != .loading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showBanner = false
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                showBanner = false
            }
        }
    }
}
