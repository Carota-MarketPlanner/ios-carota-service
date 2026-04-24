// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "NetCore",
    platforms: [.iOS(.v15), .macOS(.v10_14), .tvOS(.v12), .watchOS(.v5)],
    products: [
        .library(name: "NetCore", targets: ["NetCore"])
    ],
    targets: [
        .target(
            name: "NetCore",
            path: "NetCore/Classes"
        )
    ]
)
