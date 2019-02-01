// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "UCLKit",
    products: [
        .library(name: "UCLKit", targets: ["UCLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/nerdishbynature/RequestKit.git", .branch("master"))
    ],
    targets: [
        .target(name: "UCLKit", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKitTests", dependencies: ["UCLKit"])
   ]
)
