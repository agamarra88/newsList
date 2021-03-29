// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataAccess",
    platforms: [
            .iOS(.v13),
            .tvOS(.v13),
            .watchOS(.v6),
            .macOS(.v10_15)
        ],
    products: [
        .library(name: "DataAccess", targets: ["DataAccess"]),
    ],
    dependencies: [
        .package(name: "Model", path: "./../Model"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0"))
    ],
    targets: [
        .target(name: "DataAccess", dependencies: ["Model", "Alamofire"]),
        .testTarget(name: "DataAccessTests", dependencies: ["DataAccess"]),
    ]
)
