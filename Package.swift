// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AttributedStringBuilder",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "AttributedStringBuilder",
            targets: ["AttributedStringBuilder"]),
    ],
    dependencies: [
        .package(url: "https://github.com/chriseidhof/SwiftHighlighting", branch: "main"),
        .package(url: "https://github.com/apple/swift-markdown", branch: "main"),
    ],
    targets: [
        .target(
            name: "AttributedStringBuilder",
            dependencies: [
                .product(name: "SwiftHighlighting", package: "SwiftHighlighting"),
                .product(name: "Markdown", package: "swift-markdown"),
            ]),
        .testTarget(name: "Tests", dependencies: [
            "AttributedStringBuilder"
        ])
    ]
)
