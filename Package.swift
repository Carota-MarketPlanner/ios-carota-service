import PackageDescription

let package = Package(
    name: "CarotaService",
    platforms: [.iOS(.v12), .macOS(.v10_14), .tvOS(.v12), .watchOS(.v5)],
    products: [
        .library(name: "CarotaService", targets: ["CarotaService"])
    ],
    targets: [
        .target(
            name: "CarotaService",
            path: "CarotaService/Classes"
        )
    ]
)