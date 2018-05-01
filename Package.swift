import PackageDescription

let package = Package(
    name: "UCLKit"
    products: [.library(name: "UCLKit", targets: ["UCLKit macOS", "UCLKit iOS", "UCLKit tvOS", "UCLKit watchOS"])],
    dependencies: [.package(url: "https://github.com/nerdishbynature/RequestKit", from: "2.2.0")],
    targets: [
        .target(name: "UCLKit macOS", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKit macOS Tests", dependencies: ["UCLKit macOS"]),
        .target(name: "UCLKit iOS", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKit iOS Tests", dependencies: ["UCLKit iOS"]),
        .target(name: "UCLKit tvOS", dependencies: ["RequestKit"]),
        .testTarget(name: "UCLKit tvOS Tests", dependencies: ["UCLKit tvOS"]),
        .target(name: "UCLKit watchOS", dependencies: ["RequestKit"])],
    version: "0.1.0",
    swiftLanguageVersions: [3, 4]
)
