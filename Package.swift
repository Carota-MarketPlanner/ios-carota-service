// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "CarotaService",
    platforms: [.iOS(.v15)],
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
