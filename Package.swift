// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "UCLKit",
    products: [
        .library(name: "UCLKit", targets: ["UCLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/nerdishbynature/RequestKit.git", .branch("linux"))
    ],
    targets: [
        .target(name: "UCLKit", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKitTests", dependencies: ["UCLKit"])
   ]
)
