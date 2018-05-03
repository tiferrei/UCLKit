// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "UCLKit",
    products: [
        .library(name: "UCLKit", targets: ["UCLKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/nerdishbynature/RequestKit.git", from: "2.2.0")
    ],
    targets: [
        .target(name: "UCLKit", dependencies: ["RequestKit"], path: "Source"),
        .testTarget(name: "UCLKit Tests", dependencies: ["UCLKit"], path: "Tests")
   ]
)
