// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Lil48",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Lil48",
            targets: ["Lil48"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Lil48",
            dependencies: []),
        .testTarget(
            name: "Lil48Tests",
            dependencies: ["Lil48"]),
    ]
)