# ESDS — Infomaniak Design System (iOS)

ESDS is the Swift Package that implements Infomaniak's design system for iOS. It ships a shared, token-based visual language and a per-brand theme for every Infomaniak product — Mail, kDrive,SwissTransfer, etc.

## Architecture

The package is organized in three layers, each with its own SPM target. Tokens flow downward: primitives feed the foundation, and each product theme feeds off the foundation.

```
ESDSPrimitives   →   ESDSFoundation   →   ESDSMail / ESDSSwisstransfer / ESDSKdrive / etc.
(raw values)         (semantic tokens)
```

### 1. `ESDSPrimitives`
The raw design values, with no meaning attached yet:
- **Colors** — hue scales (aqua, blue, coral, gray, red, violet, ...) each with shades from 50 to 950, stored in `Colors.xcassets`, and exposed as `PrimitiveToken.Color.red500`, etc.
- **Spacing, radius, and scale** — plain numeric scales (`PrimitiveToken.Spacing.sixteen`, ...).
- `Color+LightDark.swift` provides the `SwiftUI.Color(light:dark:)` helper used to build adaptive colors from two primitives.

Primitives are internal building blocks — app code should never reference them directly.

### 2. `ESDSFoundation`
Defines the semantic token vocabulary as a brand-agnostic structure:
- `ESDSTheme` is the root type, composed of sub-structs: `Color`, `Icon`, `Radius`, `Spacing`.
- Each property is named by **role**, not by value (e.g. `backgroundBrandDefault`, `textFeedbackErrorDefault`, `borderDim2Hover`) so the same theme shape works for every brand.

### 3. Product targets (`ESDSMail`, `ESDSKdrive`, ...)
One target per product. Each provides a single concrete instance of `ESDSTheme` (e.g. `ESDSTheme.mail`) that maps every semantic token to the primitive values for that brand, in both light and dark mode.
This is the layer app code actually consumes.

### `ESDSTypography`
The Infomaniak Sans font and the typography presets of the design system (`ESDSTextStyle.xs` to `.sixXl`, each with an `Emphasized` variant). This target is written by hand, unlike the generated ones above, and is opt-in because it embeds the font files (~1.8 MB).

### `CatalogApp/`
A small SwiftUI app scaffold (iOS/macOS) meant to visually browse and QA the tokens/themes exposed by the Design System.

## Usage

Add the package as a Swift Package Manager dependency (in Xcode: *File → Add Package Dependencies…*, or in `Package.swift`):

```swift
.package(url: "git@github.com:Infomaniak/ios-design-system.git", branch: "main")
```

Then depend on the library matching your app's brand, e.g. for Mail:

```swift
.target(
    name: "MyApp",
    dependencies: [.product(name: "ESDSMail", package: "ios-design-system")]
)
```

Access tokens through that brand's theme instance:

```swift
import ESDSMail
import SwiftUI

struct BannerView: View {
    var body: some View {
        Text("Hello")
            .foregroundStyle(ESDSTheme.mail.color.textOnBrandDefault)
            .padding(ESDSTheme.mail.spacing.md)
            .background(ESDSTheme.mail.color.backgroundBrandDefault)
            .clipShape(ESDSTheme.mail.radius.lg)
    }
}
```

Swap `ESDSTheme.mail` for `.kdrive`, `.kchat`, `.calendar`, etc. to theme a different app — the token names stay identical across brands.

## Typography

Add the `ESDSTypography` product, then set the font once at the root of the app:

```swift
import ESDSTypography
import SwiftUI

@main
struct MyApp: App {
    init() {
        // Navigation titles, bar buttons, tab bar items and segmented pickers
        InfomaniakSans.applyToSystemAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .font(.md) // Default font of every text without an explicit one
        }
    }
}
```

Then use the presets where a different style is needed:

```swift
Text("Title").font(.twoXlEmphasized)
Text("Caption").font(.xs)
label.font = .infomaniakSans(.md) // UIKit, with adjustsFontForContentSizeCategory = true
```

- The font is registered automatically on first use, so `UIAppFonts` isn't needed.
- Text scales with Dynamic Type, and gets heavier when Bold Text is enabled with the `font(_:)` modifier and `UIFont.infomaniakSans(_:compatibleWith:)`. A bare `Font.infomaniakSans(size:weight:relativeTo:)` doesn't react to Bold Text.
- `.font(.body)`, `.font(.headline)`, etc. still use the system font: use `.font(ESDSTextStyle(.headline))` to get the Infomaniak Sans equivalent of a system text style.
- Alerts, menus and system sheets always use the system font.
