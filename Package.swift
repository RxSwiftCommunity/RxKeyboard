// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "RxKeyboard",
  products: [
    .library(name: "RxKeyboard", targets: ["RxKeyboard"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .branch("rxswift4.0-swift4.0")),
  ],
  targets: [
    .target(name: "RxKeyboard", dependencies: ["RxSwift"]),
  ]
)
