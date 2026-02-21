// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KaitoKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "KaitoKit",
            targets: ["KaitoKit"]),
    ],
    targets: [
        .target(
            name: "KaitoKit",
            dependencies: []),
        .testTarget(
            name: "KaitoKitTests",
            dependencies: ["KaitoKit"]),
    ]
)
