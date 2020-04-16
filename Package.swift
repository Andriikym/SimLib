// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimLib",
    platforms: [.macOS(.v10_14)],
    products: [
        .library(
            name: "SimLib",
            targets: ["SimLib"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SimLib",
            dependencies: []),
        .testTarget(
            name: "SimLibTests",
            dependencies: ["SimLib"]),
    ]
)
