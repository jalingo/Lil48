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
        .executable(
            name: "Lil48App",
            targets: ["Lil48App"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Lil48",
            dependencies: []),
        .executableTarget(
            name: "Lil48App",
            dependencies: ["Lil48"]),
        .testTarget(
            name: "Lil48Tests",
            dependencies: ["Lil48"]),
    ]
)
