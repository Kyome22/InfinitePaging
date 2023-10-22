// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "InfinitePaging",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "InfinitePaging",
            targets: ["InfinitePaging"]
        )
    ],
    targets: [
        .target(
            name: "InfinitePaging"
        )
    ]
)
