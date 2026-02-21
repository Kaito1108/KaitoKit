import SwiftUI

/// 六角形Shape
public struct Hexagon: Shape {
    public var cornerRadius: CGFloat = 7

    public init(cornerRadius: CGFloat = 7) {
        self.cornerRadius = cornerRadius
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2

        let radius = min(width, height) / 2

        var points: [CGPoint] = []
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            points.append(CGPoint(x: x, y: y))
        }

        for i in 0..<6 {
            let current = points[i]
            let next = points[(i + 1) % 6]
            let prev = points[(i + 5) % 6]

            let toNext = CGPoint(x: next.x - current.x, y: next.y - current.y)
            let toPrev = CGPoint(x: prev.x - current.x, y: prev.y - current.y)

            let lengthToNext = sqrt(toNext.x * toNext.x + toNext.y * toNext.y)
            let lengthToPrev = sqrt(toPrev.x * toPrev.x + toPrev.y * toPrev.y)

            let normalizedToNext = CGPoint(x: toNext.x / lengthToNext, y: toNext.y / lengthToNext)
            let normalizedToPrev = CGPoint(x: toPrev.x / lengthToPrev, y: toPrev.y / lengthToPrev)

            let startPoint = CGPoint(
                x: current.x + normalizedToPrev.x * cornerRadius,
                y: current.y + normalizedToPrev.y * cornerRadius
            )
            let endPoint = CGPoint(
                x: current.x + normalizedToNext.x * cornerRadius,
                y: current.y + normalizedToNext.y * cornerRadius
            )

            if i == 0 {
                path.move(to: startPoint)
            }

            path.addLine(to: startPoint)
            path.addQuadCurve(to: endPoint, control: current)
        }

        path.closeSubpath()
        return path
    }
}

#if canImport(UIKit)
import UIKit

/// カスタム角丸Shape
public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    /// 特定の角のみ角丸にする
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
#endif
