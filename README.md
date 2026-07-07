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
