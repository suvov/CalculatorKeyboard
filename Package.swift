// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Calcboard",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Calcboard",
            targets: ["Calcboard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Calcboard",
            dependencies: []),
        .testTarget(
            name: "CalcboardTests",
            dependencies: ["Calcboard"]),
    ]
)
