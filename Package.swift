// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "InfinitePaging",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "InfinitePaging",
            targets: ["InfinitePaging"]
        ),
    ],
    targets: [
        .target(
            name: "InfinitePaging",
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
    ]
)
