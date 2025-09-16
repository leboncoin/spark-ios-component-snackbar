// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable all
let package = Package(
    name: "SparkComponentSnackbar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SparkComponentSnackbar",
            targets: ["SparkComponentSnackbar"]
        ),
        .library(
            name: "SparkComponentSnackbarTesting",
            targets: ["SparkComponentSnackbarTesting"]
        )
    ],
    dependencies: [
       .package(
           url: "https://github.com/leboncoin/spark-ios-common.git",
           // path: "../spark-ios-common"
           /*version*/ "0.0.1"..."999.999.999"
       ),
       .package(
           url: "https://github.com/leboncoin/spark-ios-theming.git",
           // path: "../spark-ios-theming"
           /*version*/ "0.0.1"..."999.999.999"
       ),
       .package(
           url: "https://github.com/leboncoin/spark-ios-component-button.git",
           // path: "../spark-ios-component-button"
           /*version*/ "0.0.1"..."999.999.999"
       )
    ],
    targets: [
        .target(
            name: "SparkComponentSnackbar",
            dependencies: [
                .product(
                    name: "SparkCommon",
                    package: "spark-ios-common"
                ),
                .product(
                    name: "SparkTheming",
                    package: "spark-ios-theming"
                ),
                .product(
                    name: "SparkComponentButton",
                    package: "spark-ios-component-button"
                )
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "SparkComponentSnackbarTesting",
            dependencies: [
                "SparkComponentSnackbar",
                .product(
                    name: "SparkCommon",
                    package: "spark-ios-common"
                ),
                .product(
                    name: "SparkCommonTesting",
                    package: "spark-ios-common"
                ),
                .product(
                    name: "SparkThemingTesting",
                    package: "spark-ios-theming"
                ),
                .product(
                    name: "SparkTheme",
                    package: "spark-ios-theming"
                )
            ],
            path: "Sources/Testing"
        ),
        .testTarget(
            name: "SparkComponentSnackbarUnitTests",
            dependencies: [
                "SparkComponentSnackbar",
                "SparkComponentSnackbarTesting",
                .product(
                    name: "SparkCommonTesting",
                    package: "spark-ios-common"
                ),
                .product(
                    name: "SparkThemingTesting",
                    package: "spark-ios-theming"
                )
            ],
            path: "Tests/UnitTests"
        ),
        .testTarget(
            name: "SparkComponentSnackbarSnapshotTests",
            dependencies: [
                "SparkComponentSnackbar",
                "SparkComponentSnackbarTesting",
                .product(
                    name: "SparkCommonSnapshotTesting",
                    package: "spark-ios-common"
                ),
            ],
            path: "Tests/SnapshotTests"
        )
    ]
)
