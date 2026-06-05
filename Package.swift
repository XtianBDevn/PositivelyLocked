// swift-tools-version: 5.9
// This is provided as reference. The primary build system is the Xcode project.
// Open PositivelyLocked.xcodeproj in Xcode to build and run.

import PackageDescription

let package = Package(
    name: "PositivelyLocked",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PositivelyLocked",
            targets: ["PositivelyLocked"]
        ),
    ],
    targets: [
        .target(
            name: "PositivelyLocked",
            path: "Shared"
        ),
    ]
)
