// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "InfinitePagingView",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "InfinitePagingView",
            targets: ["InfinitePagingView"]
        )
    ],
    targets: [
        .target(
            name: "InfinitePagingView"
        )
    ]
)
