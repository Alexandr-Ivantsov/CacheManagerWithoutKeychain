// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Factory": .framework,
        "CryptoSwift": .framework
    ]
)
#endif

let package = Package(
    name: "CacheManagerWithoutKeychain",
    products: [
        .library(name: "CacheManagerWithoutKeychain", targets: ["CacheManagerWithoutKeychain"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.5.2")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git" , .upToNextMajor(from: "1.8.4"))
    ],
    targets: [
        .target(name: "CacheManagerWithoutKeychain",
                dependencies: [])
    ]
)


