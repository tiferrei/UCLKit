// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "UCLKit",
    products: [
        .library(name: "UCLKit", targets: ["UCLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/nerdishbynature/RequestKit.git", .branch("xcode-10.2"))
    ],
    targets: [
        .target(name: "UCLKit", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKitTests", dependencies: ["UCLKit"])
   ]
)
