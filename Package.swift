// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bus",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "Bus", targets: ["Bus"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Bus", dependencies: []),
        .testTarget(name: "BusTests", dependencies: ["Bus"]),
    ]
)
