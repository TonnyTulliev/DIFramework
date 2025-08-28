// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DIFramework",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "DIFramework",
            targets: ["DIFramework"]),
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "DIFramework",
            dependencies: [],
            path: "Sources/DIFramework"
        ),
        .testTarget(
            name: "DIFrameworkTests",
            dependencies: ["DIFramework"],
            path: "Tests/DIFrameworkTests"
        ),
    ]
)
