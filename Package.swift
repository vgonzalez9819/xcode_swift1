// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SwiftUIFormApp",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    targets: [
        .executableTarget(
            name: "SwiftUIFormApp",
            path: "Sources/SwiftUIFormApp",
            linkerSettings: [
                .linkedLibrary("sqlite3")
            ]
        ),
        .testTarget(
            name: "SwiftUIFormAppTests",
            dependencies: ["SwiftUIFormApp"],
            path: "Tests/SwiftUIFormAppTests"
        )
    ]
)
