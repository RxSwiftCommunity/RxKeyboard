// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RxKeyboard",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)
    ],
    products: [
        .library(name: "RxKeyboard", targets: ["RxKeyboard"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(name: "RxKeyboard", dependencies: ["RxSwift", "RxCocoa"]),
    ]
)
