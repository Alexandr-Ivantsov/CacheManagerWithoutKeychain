import ProjectDescription

let project = Project(
    name: "CacheManagerWithoutKeychain",
    targets: [
        .target(
            name: "CacheManagerWithoutKeychain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.CacheManagerWithoutKeychain",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Factory"),
                .external(name: "CryptoSwift")
            ]
        ),
        .target(
            name: "CacheManagerWithoutKeychainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CacheManagerWithoutKeychainTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "CacheManagerWithoutKeychain")]
        )
    ]
)



