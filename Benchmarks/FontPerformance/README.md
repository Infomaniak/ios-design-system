# Font performance benchmarks: Infomaniak Sans vs SF

A small standalone iOS app that compares the system font (SF) with **Infomaniak Sans** (variable font from [Infomaniak/design-system](https://github.com/Infomaniak/design-system/tree/main/packages/assets/fonts/fonts/infomaniak-sans)).
The same binary runs either font, selected at launch, so runs can be alternated to limit thermal and caching bias.

It is independent from the `ESDS` package: nothing here ships in the design system.

## Requirements

- Xcode with an iOS simulator, or a paired iPhone (unlocked, screen on during runs)
- [Tuist](https://tuist.dev) 4.x (pinned in `.mise.toml`)

## Setup

```bash
cd Benchmarks/FontPerformance
# With mise: trust the repo and benchmark configs once, otherwise `tuist` fails here
mise trust ../../.mise.toml && mise trust .mise.toml && mise install
scripts/fetch_fonts.sh          # downloads the .ttf files (not committed)
tuist generate --no-open

# Simulator
xcodebuild -project FontPerfTest.xcodeproj -scheme FontPerfTest -configuration Release \
  -destination 'id=<SIMULATOR_UDID>' -derivedDataPath DerivedData build
xcrun simctl install <SIMULATOR_UDID> DerivedData/Build/Products/Release-iphonesimulator/FontPerfTest.app

# iPhone (signing uses the Infomaniak team, change DEVELOPMENT_TEAM in Project.swift if needed)
xcodebuild -project FontPerfTest.xcodeproj -scheme FontPerfTest -configuration Release \
  -destination 'id=<DEVICE_UDID>' -derivedDataPath DerivedData -allowProvisioningUpdates build
xcrun devicectl device install app --device <DEVICE_UDID> DerivedData/Build/Products/Release-iphoneos/FontPerfTest.app
```

UDIDs: `xcrun simctl list devices` and `xcrun devicectl list devices`.

## Running

```bash
# Measurements: N launches per font, alternated, median printed at the end
scripts/run_bench.sh sim <UDID> 6 micro
scripts/run_bench.sh sim <UDID> 6 extended
scripts/run_bench.sh device <UDID> 6 micro

# Instruments: one Time Profiler trace per font + CPU time per phase
scripts/record_traces.sh sim <UDID> micro
scripts/record_traces.sh sim <UDID> extended
```

Raw results go to `results/*.jsonl`, traces to `traces/*.trace` (open them in Instruments, phases are visible under *Points of Interest*).
Durations: `micro` ≈ 15 s per launch, `extended` ≈ 2 min per launch.

The app can also be launched by hand with the arguments `-font sf|ims -suite micro|extended`.

## What is measured

### `micro` suite (`Bench.swift`, `ScrollTestView.swift`)

| Metric | Description |
|---|---|
| `register_ms` | `CTFontManagerRegisterFontsForURL` for both files (Infomaniak Sans only) |
| `first_use_ms` | First font creation + layout of a short string |
| `font_creation_*` | Creating 40 fonts (4 weights × 10 sizes), first time and again |
| `ct_layout_*` | CoreText layout of 2000 lines (cold = first pass, warm = median of 7) |
| `raster_*` | Drawing those lines into a bitmap |
| `swiftui_render_*` | `ImageRenderer` of 200 `Text` views, new text on each repetition |
| `scroll_*` | Lazy `List` of 2000 rows auto-scrolled at 4000 pt/s for 8 s, frame pacing and hitches |
| `weight_applied` | Checks `.weight()` really changes the weight of the variable font |

### `extended` suite (`Extended.swift`)

App with a `TabView`, `NavigationStack` with a large title, toolbar button, and a list with thumbnails, several scripts and italic text. Bars are configured with `UINavigationBarAppearance` / `UITabBarAppearance`.

| Metric | Description |
|---|---|
| `check_navtitle_*` | Font actually used by the navigation title, and its size at default and accessibility sizes |
| `check_opsz_*` | Optical size axis is applied automatically (CoreText and SwiftUI) |
| `check_italic_*` | `.italic()` / italic trait use the real italic file |
| `script_*` | Layout of 500 lines per script (Latin, Cyrillic, Greek, Arabic, Chinese, Japanese, emoji), and whether a fallback font is used |
| `italic_layout_*` | Layout of 2000 italic lines |
| `dyntype_*_render_*` | SwiftUI text styles rendered at default (`large`) and `accessibility3` sizes |
| `launch_to_first_frame_ms`, `memory_*` | Launch time and memory footprint |
| `appearance_config_ms` | Cost of configuring the bars (Infomaniak Sans only) |
| `ui_pushpop_*`, `ui_tabs_*`, `ui_dyntype_change_*`, `ui_feed_scroll_*` | Hitches during navigation, tab switches, text size changes at runtime, realistic scroll |
| `ui_all_at_once_*` | Accessibility size + scroll + navigation + tabs together |

## Known limitations

- The simulator is capped at 60 fps: compare fonts with each other, not absolute values.
- Scrolls and navigations are automated, not finger-driven. No network or real images.
- Not measured: Bold Text accessibility setting, readability at the largest sizes, alerts / menus / system sheets (always the system font).
- `xctrace` sometimes hangs while saving a trace: `record_traces.sh` kills it after the time limit + 3 min. Re-run if a trace is missing.
- Results vary between launches: always use several runs and compare medians.
