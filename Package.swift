// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ESDS",
    platforms: [.iOS(.v16), .macOS(.v13), .visionOS(.v1)],
    products: [
        .library(
            name: "ESDSFoundation",
            targets: ["ESDSFoundation"]
        ),
        .library(
            name: "ESDSCalendar",
            targets: ["ESDSCalendar"]
        ),
        .library(
            name: "ESDSContacts",
            targets: ["ESDSContacts"]
        ),
        .library(
            name: "ESDSEuria",
            targets: ["ESDSEuria"]
        ),
        .library(
            name: "ESDSInfomaniak",
            targets: ["ESDSInfomaniak"]
        ),
        .library(
            name: "ESDSKchat",
            targets: ["ESDSKchat"]
        ),
        .library(
            name: "ESDSKdrive",
            targets: ["ESDSKdrive"]
        ),
        .library(
            name: "ESDSKnote",
            targets: ["ESDSKnote"]
        ),
        .library(
            name: "ESDSMail",
            targets: ["ESDSMail"]
        ),
        .library(
            name: "ESDSSecurity",
            targets: ["ESDSSecurity"]
        ),
        .library(
            name: "ESDSSwisstransfer",
            targets: ["ESDSSwisstransfer"]
        ),
    ],
    targets: [
        .target(
            name: "ESDSPrimitives",
            resources: [.process("Colors.xcassets")]
        ),
        .target(
            name: "ESDSFoundation",
            dependencies: ["ESDSPrimitives"]
        ),
        .target(
            name: "ESDSCalendar",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSCalendar"
        ),
        .target(
            name: "ESDSContacts",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSContacts"
        ),
        .target(
            name: "ESDSEuria",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSEuria"
        ),
        .target(
            name: "ESDSInfomaniak",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSInfomaniak"
        ),
        .target(
            name: "ESDSKchat",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSKchat"
        ),
        .target(
            name: "ESDSKdrive",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSKdrive"
        ),
        .target(
            name: "ESDSKnote",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSKnote"
        ),
        .target(
            name: "ESDSMail",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSMail"
        ),
        .target(
            name: "ESDSSecurity",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSSecurity"
        ),
        .target(
            name: "ESDSSwisstransfer",
            dependencies: ["ESDSFoundation", "ESDSPrimitives"],
            path: "Sources/Products/ESDSSwisstransfer"
        ),
    ]
)