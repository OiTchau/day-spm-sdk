// swift-tools-version: 5.9

import PackageDescription

// The Day.io SDK for iOS 15 and later: add this package and use the DaySDK product - nothing else to
// add, link or embed.
//
// The host app brings its own Google Maps (through SwiftPM), as it brings its own Maps key. SwiftPM
// resolves ONE version for the whole app - the app's own, if it has one - and the SDK draws with it.
// DaySDK.framework doesn't contain Google Maps, so there is never a second copy.
//
// Google Maps stays on 9.x, the last line that runs on iOS 15: Xcode checks each package target
// against its dependencies, so this package's iOS 15 targets can't depend on 10.x or later (iOS 16),
// whatever the app's own minimum. An app on Google Maps 10.x or later can't resolve this package -
// lift the range together with the platform to .v16 once iOS 15 is dropped.

// DaySDK.xcframework from download.day.io. scripts/release-sdk.sh writes the version and checksum of
// the release it builds, and stages this package for https://github.com/OiTchau/day-spm-sdk.
let daySdkVersion = "1.0.3"
let daySdkChecksum = "a86090ab133d4d08b3d70cfbb87c07b14a3def37c76a7bb484318d5c5c0cee9d"

let package = Package(
    name: "DaySDK",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "DaySDK", targets: ["DaySDKGoogleMaps"]),
    ],
    dependencies: [
        // 9.x only while the package supports iOS 15 (see above).
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", "9.4.0"..<"10.0.0"),
        // The SQLCipher DaySDK.framework links against.
        .package(url: "https://github.com/sqlcipher/SQLCipher.swift", exact: "4.19.0"),
    ],
    targets: [
        .binaryTarget(
            name: "DaySDK",
            url: "https://download.day.io/sdk/ios/\(daySdkVersion)/DaySDK.xcframework.zip",
            checksum: daySdkChecksum
        ),
        // Draws the SDK's maps with Google Maps (DaySDK.framework doesn't contain it). A copy of
        // ios/DaySDKGoogleMaps in the SDK repository.
        .target(
            name: "DaySDKGoogleMaps",
            dependencies: [
                "DaySDK",
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "SQLCipher", package: "SQLCipher.swift"),
            ]
        ),
    ]
)
