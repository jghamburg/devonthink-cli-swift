// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "devonthink-cli-swift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "dt", targets: ["dt"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.3.0"
        ),
    ],
    targets: [
        // ObjC implementation stubs for ScriptingBridge proxy classes.
        // Provides @implementation for DEVONthinkApplication, DEVONthinkRecord, etc.
        // so dyld can resolve OBJC_CLASS_$_* symbols at runtime.
        .target(
            name: "DevonthinkBridge",
            path: "Sources/DevonthinkBridge",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("ScriptingBridge"),
            ]
        ),
        // Core library shared by both executables
        .target(
            name: "DevonthinkCore",
            dependencies: [
                "DevonthinkBridge",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/DevonthinkCore",
            swiftSettings: [
                .unsafeFlags([
                    "-import-objc-header",
                    "Sources/DevonthinkCore/Bridge/DevonthinkCore-Bridging-Header.h",
                    "-disable-bridging-pch",
                ]),
            ],
            linkerSettings: [
                .linkedFramework("ScriptingBridge"),
                .unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"]),
            ]
        ),
        // Primary binary: dt
        .executableTarget(
            name: "dt",
            dependencies: ["DevonthinkCore"],
            path: "Sources/dt"
        ),
    ]
)
