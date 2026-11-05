import ProjectDescription

let project = Project(
    name: "FontPerfTest",
    targets: [
        .target(
            name: "FontPerfTest",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.infomaniak.FontPerfTest",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:],
                "CADisableMinimumFrameDurationOnPhone": true
            ]),
            sources: ["FontPerfTest/Sources/**"],
            resources: ["FontPerfTest/Resources/**"],
            settings: .settings(base: [
                "SWIFT_VERSION": "5.0",
                "DEVELOPMENT_TEAM": "864VDCS2QY",
                "CODE_SIGN_STYLE": "Automatic"
            ])
        )
    ]
)
