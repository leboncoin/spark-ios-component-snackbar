// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable all
let package = Package(
    name: "SparkSnackbar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SparkSnackbar",
            targets: ["SparkSnackbar"]
        ),
        .library(
            name: "SparkSnackbarTesting",
            targets: ["SparkSnackbarTesting"]
        )
    ],
    dependencies: [
       .package(
           url: "https://github.com/adevinta/spark-ios-common.git",
           // path: "../spark-ios-common"
           /*version*/ "0.0.1"..."999.999.999"
       ),
       .package(
           url: "https://github.com/adevinta/spark-ios-theming.git",
           // path: "../spark-ios-theming"
           /*version*/ "0.0.1"..."999.999.999"
       )
    ],
    targets: [
        .target(
            name: "SparkSnackbar",
            dependencies: [
                .product(
                    name: "SparkCommon",
                    package: "spark-ios-common"
                ),
                .product(
                    name: "SparkTheming",
                    package: "spark-ios-theming"
                )
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "SparkSnackbarTesting",
            dependencies: [
                "SparkSnackbar",
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
            name: "SparkSnackbarUnitTests",
            dependencies: [
                "SparkSnackbar",
                "SparkSnackbarTesting",
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
//        .testTarget(
//            name: "SparkSnackbarSnapshotTests",
//            dependencies: [
//                "SparkSnackbar",
//                "SparkSnackbarTesting",
//                .product(
//                    name: "SparkCommonSnapshotTesting",
//                    package: "spark-ios-common"
//                ),
//            ],
//            path: "Tests/SnapshotTests"
//        ),
    ]
)
