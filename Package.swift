// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CalculatorKeyboard",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CalculatorKeyboard",
            targets: ["CalculatorKeyboard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CalculatorKeyboard",
            dependencies: []),
        .testTarget(
            name: "CalculatorKeyboardTests",
            dependencies: ["CalculatorKeyboard"]),
    ]
)
