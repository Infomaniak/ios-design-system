/*
 Infomaniak Design System - iOS App
 Copyright (C) 2026 Infomaniak Network SA

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import CoreText
import SwiftUI
import UIKit

/// Extended suite: system bars, Dynamic Type, optical size, italic, non-Latin scripts,
/// launch time, memory, realistic screens, and everything combined.
@MainActor
enum Extended {
    static let processStart: Date = {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        sysctl(&mib, 4, &info, &size, nil, 0)
        let t = info.kp_proc.p_starttime
        return Date(timeIntervalSince1970: Double(t.tv_sec) + Double(t.tv_usec) / 1e6)
    }()

    static let scripts: [(String, String)] = [
        ("latin", "Partagez vos fichiers en toute sécurité avec kDrive, hébergé en Suisse à Genève."),
        ("cyrillic", "Съешь же ещё этих мягких французских булок, да выпей чаю. Облачное хранилище."),
        ("greek", "Ξεσκεπάζω την ψυχοφθόρα βδελυγμία. Ασφαλές νέφος και ηλεκτρονικό ταχυδρομείο."),
        ("arabic", "نص حكيم له سر قاطع وذو شأن عظيم مكتوب على ثوب أخضر ومغلف بجلد أزرق"),
        ("chinese", "我能吞下玻璃而不伤身体。安全的云存储和电子邮件服务，数据保存在瑞士。"),
        ("japanese", "いろはにほへと ちりぬるを わかよたれそ つねならむ クラウドストレージ"),
        ("emoji", "Partage 📁 terminé ✅ merci 🙏 à bientôt 👋🏽 🇨🇭 🎉 ☁️ 🔒 📧 🗓️")
    ]

    static let baseSizes: [Font.TextStyle: CGFloat] = [
        .largeTitle: 34, .title: 28, .title2: 22, .title3: 20, .headline: 17, .body: 17,
        .callout: 16, .subheadline: 15, .footnote: 13, .caption: 12, .caption2: 11
    ]

    static func styled(_ style: Font.TextStyle, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        var font: Font
        switch Bench.kind {
        case .sf: font = .system(style)
        case .ims: font = .custom("Infomaniak Sans", size: baseSizes[style] ?? 17, relativeTo: style)
        }
        font = font.weight(weight)
        return italic ? font.italic() : font
    }

    // MARK: Appearance

    static func imsUIFont(size: CGFloat, wght: CGFloat, style: UIFont.TextStyle) -> UIFont {
        let desc = UIFontDescriptor(fontAttributes: [
            .name: "InfomaniakSans",
            UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String): [0x7767_6874: wght]
        ])
        return UIFontMetrics(forTextStyle: style).scaledFont(for: UIFont(descriptor: desc, size: size))
    }

    static func configureAppearance() {
        guard Bench.kind == .ims else { return }
        let state = Bench.signposter.beginInterval("appearanceConfig")
        let elapsed = ContinuousClock().measure {
            let nav = UINavigationBarAppearance()
            nav.configureWithDefaultBackground()
            nav.titleTextAttributes = [.font: imsUIFont(size: 17, wght: 600, style: .headline)]
            nav.largeTitleTextAttributes = [.font: imsUIFont(size: 34, wght: 700, style: .largeTitle)]
            let button = UIBarButtonItemAppearance()
            button.normal.titleTextAttributes = [.font: imsUIFont(size: 17, wght: 400, style: .body)]
            nav.buttonAppearance = button
            nav.backButtonAppearance = button
            UINavigationBar.appearance().standardAppearance = nav
            UINavigationBar.appearance().scrollEdgeAppearance = nav
            UINavigationBar.appearance().compactAppearance = nav

            let tab = UITabBarAppearance()
            tab.configureWithDefaultBackground()
            let tabFont = imsUIFont(size: 10, wght: 500, style: .caption2)
            for item in [tab.stackedLayoutAppearance, tab.inlineLayoutAppearance, tab.compactInlineLayoutAppearance] {
                item.normal.titleTextAttributes = [.font: tabFont]
                item.selected.titleTextAttributes = [.font: tabFont]
            }
            UITabBar.appearance().standardAppearance = tab
            UITabBar.appearance().scrollEdgeAppearance = tab
        }
        Bench.signposter.endInterval("appearanceConfig", state)
        Bench.results["appearance_config_ms"] = elapsed.ms
    }

    // MARK: Micro benchmarks & checks

    static func runMicro() {
        let r = { (k: String, v: Double) in Bench.results[k] = v }

        // Non-Latin scripts: layout cost and fallback detection.
        let base: CTFont = Bench.ctFont(size: 17, weight: .regular, wght: 400)
        for (name, sample) in scripts {
            let strings = (0 ..< 500).map { NSAttributedString(string: "\($0) \(sample)", attributes: [.font: base]) }
            r("script_\(name)_cold_ms", Bench.measure("scriptCold") { Bench.layout(strings) })
            r(
                "script_\(name)_warm_ms",
                Bench.median((0 ..< 5).map { _ in Bench.measure("scriptWarm") { Bench.layout(strings) } })
            )
            r("script_\(name)_fallback", usesFallback(sample, font: base) ? 1 : 0)
        }

        // Italic layout.
        let italicFonts = Bench.sizes.map { italicCTFont(size: $0) }
        let italicStrings = Bench.corpus.enumerated().map { i, s in
            NSAttributedString(string: s, attributes: [.font: italicFonts[i % italicFonts.count]])
        }
        r("italic_layout_cold_ms", Bench.measure("italicCold") { Bench.layout(italicStrings) })
        r(
            "italic_layout_warm_ms",
            Bench.median((0 ..< 7).map { _ in Bench.measure("italicWarm") { Bench.layout(italicStrings) } })
        )

        // Dynamic Type rendering (SwiftUI, text styles) at default vs accessibility size.
        for (key, size) in [("large", DynamicTypeSize.large), ("ax3", .accessibility3)] {
            r("dyntype_\(key)_render_cold_ms", Bench.measure("dynTypeCold") { renderStyled(size: size, offset: 0) })
            r(
                "dyntype_\(key)_render_warm_ms",
                Bench.median((1 ... 8).map { i in Bench.measure("dynTypeWarm") { renderStyled(size: size, offset: i * 150) } })
            )
        }

        // Correctness checks (Infomaniak Sans only).
        guard Bench.kind == .ims else { return }
        let text = "Hamburgefonstiv Infomaniak 0123"
        let w32Default = lineWidth(text, CTFontCreateWithName("InfomaniakSans" as CFString, 32, nil))
        let w32Opsz14 = lineWidth(text, imsCTFont(size: 32, axes: [0x6F70_737A: 14]))
        let w32Opsz32 = lineWidth(text, imsCTFont(size: 32, axes: [0x6F70_737A: 32]))
        let wSwiftUI = swiftUIWidth(text, font: .custom("Infomaniak Sans", size: 32))
        print("OPSZ default=\(w32Default) opsz14=\(w32Opsz14) opsz32=\(w32Opsz32) swiftui=\(wSwiftUI)")
        r("check_opsz_axis_changes_width", abs(w32Opsz14 - w32Opsz32) > 0.5 ? 1 : 0)
        r("check_opsz_auto_coretext", abs(w32Default - w32Opsz32) < abs(w32Default - w32Opsz14) ? 1 : 0)
        r("check_opsz_auto_swiftui", abs(wSwiftUI - w32Opsz32) < abs(wSwiftUI - w32Opsz14) ? 1 : 0)

        let regularW = lineWidth(text, imsCTFont(size: 32, axes: [:]))
        let italicW = lineWidth(text, CTFontCreateWithName("InfomaniakSansItalic" as CFString, 32, nil))
        let swiftUIItalicW = swiftUIWidth(text, font: .custom("Infomaniak Sans", size: 32).italic())
        print("ITALIC regular=\(regularW) realItalic=\(italicW) swiftuiItalic=\(swiftUIItalicW)")
        r("check_italic_real_swiftui", abs(swiftUIItalicW - italicW) < abs(swiftUIItalicW - regularW) ? 1 : 0)
        let uiItalic = UIFont(
            descriptor: UIFontDescriptor(name: "InfomaniakSans", size: 17).withSymbolicTraits(.traitItalic)!,
            size: 17
        )
        print("ITALIC uikit fontName=\(uiItalic.fontName)")
        r("check_italic_real_uikit", uiItalic.fontName.contains("Italic") ? 1 : 0)
    }

    static func italicCTFont(size: CGFloat) -> CTFont {
        switch Bench.kind {
        case .sf:
            let d = UIFont.systemFont(ofSize: size).fontDescriptor.withSymbolicTraits(.traitItalic)!
            return UIFont(descriptor: d, size: size) as CTFont
        case .ims:
            return CTFontCreateWithName("InfomaniakSansItalic" as CFString, size, nil)
        }
    }

    static func imsCTFont(size: CGFloat, axes: [Int: CGFloat]) -> CTFont {
        let desc = CTFontDescriptorCreateWithAttributes([
            kCTFontNameAttribute: "InfomaniakSans",
            kCTFontVariationAttribute: axes
        ] as CFDictionary)
        return CTFontCreateWithFontDescriptor(desc, size, nil)
    }

    static func lineWidth(_ s: String, _ font: CTFont) -> Double {
        CTLineGetTypographicBounds(
            CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: [.font: font])),
            nil,
            nil,
            nil
        )
    }

    static func swiftUIWidth(_ s: String, font: Font) -> Double {
        let r = ImageRenderer(content: Text(s).font(font).fixedSize())
        r.scale = 4
        return Double(r.cgImage?.width ?? 0) / 4
    }

    static func usesFallback(_ s: String, font: CTFont) -> Bool {
        let primary = CTFontCopyFamilyName(font) as String
        let line = CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: [.font: font]))
        let runs = CTLineGetGlyphRuns(line) as! [CTRun]
        return runs.contains { run in
            let attrs = CTRunGetAttributes(run) as NSDictionary
            let f = attrs[kCTFontAttributeName] as! CTFont
            return (CTFontCopyFamilyName(f) as String) != primary
        }
    }

    static func renderStyled(size: DynamicTypeSize, offset: Int) {
        let styles: [Font.TextStyle] = [
            .largeTitle,
            .title,
            .title2,
            .title3,
            .headline,
            .body,
            .callout,
            .subheadline,
            .footnote,
            .caption,
            .caption2
        ]
        let view = VStack(alignment: .leading, spacing: 4) {
            ForEach(0 ..< 150, id: \.self) { i in
                Text(Bench.corpus[(offset + i) % Bench.corpus.count])
                    .font(styled(styles[i % styles.count], weight: Bench.weights[i % 4].swiftUI))
            }
        }
        .frame(width: 390)
        .environment(\.dynamicTypeSize, size)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3
        precondition(renderer.cgImage != nil)
    }

    // MARK: Helpers

    static func footprintMB() -> Double {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
        let kr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        return kr == KERN_SUCCESS ? Double(info.phys_footprint) / 1_048_576 : -1
    }

    static var window: UIWindow? {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap(\.windows).first
    }

    /// Visible label showing `text` with the largest point size (large title when expanded).
    static func label(_ text: String) -> UILabel? {
        guard let window else { return nil }
        var best: UILabel?
        func visit(_ v: UIView) {
            if let l = v as? UILabel, l.text == text, !l.isHidden, l.alpha > 0.01,
               l.font.pointSize > (best?.font.pointSize ?? 0) {
                best = l
            }
            v.subviews.forEach(visit)
        }
        visit(window)
        return best
    }

    static func record(_ prefix: String, _ s: ScrollStats) {
        Bench.results["\(prefix)_hitches"] = Double(s.hitches)
        Bench.results["\(prefix)_hitch_ratio_ms_per_s"] = s.hitchRatio
        Bench.results["\(prefix)_frame_p95_ms"] = s.p95
        Bench.results["\(prefix)_frame_max_ms"] = s.max
        Bench.results["\(prefix)_frames"] = Double(s.frames)
    }
}

// MARK: - UI scenarios

@MainActor
final class ScenarioModel: ObservableObject {
    @Published var tab = 0
    @Published var path: [Int] = []
}

struct ExtendedRootView: View {
    @StateObject private var model = ScenarioModel()
    @State private var started = false

    var body: some View {
        TabView(selection: $model.tab) {
            NavigationStack(path: $model.path) {
                FeedList()
                    .navigationTitle("Infomaniak")
                    .navigationDestination(for: Int.self) { DetailView(index: $0) }
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Modifier") {} } }
            }
            .tabItem { Label("Fichiers", systemImage: "folder") }
            .tag(0)

            NavigationStack {
                List(0 ..< 60, id: \.self) { Text("Partagé \($0)") }.navigationTitle("Partagés")
            }
            .tabItem { Label("Partagés", systemImage: "person.2") }
            .tag(1)

            NavigationStack {
                List(0 ..< 30, id: \.self) { Text("Réglage \($0)") }.navigationTitle("Réglages")
            }
            .tabItem { Label("Réglages", systemImage: "gear") }
            .tag(2)
        }
        .font(Extended.styled(.body))
        .onAppear {
            guard !started else { return }
            started = true
            DispatchQueue.main.async {
                Bench.results["launch_to_first_frame_ms"] = Date().timeIntervalSince(Extended.processStart) * 1000
                Bench.results["memory_first_frame_mb"] = Extended.footprintMB()
                Task { await ScenarioRunner(model: model).run() }
            }
        }
    }
}

struct FeedList: View {
    var body: some View {
        List(0 ..< Bench.corpus.count, id: \.self) { i in
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [.blue, Color(hue: Double(i % 30) / 30, saturation: 0.6, brightness: 0.9)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                    .overlay(Image(systemName: ["doc", "photo", "folder", "envelope"][i % 4]).foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 2) {
                    Text(Bench.corpus[i]).font(Extended.styled(.headline, weight: .semibold)).lineLimit(1)
                    Text(Extended.scripts[i % Extended.scripts.count].1).font(Extended.styled(.subheadline)).lineLimit(2)
                    Text("Modifié il y a \(i % 59 + 1) min · \(i % 900 + 12) Ko")
                        .font(Extended.styled(.caption, italic: true))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct DetailView: View {
    let index: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(Bench.corpus[index]).font(Extended.styled(.title, weight: .bold))
                ForEach(Extended.scripts, id: \.0) { _, sample in
                    Text(sample).font(Extended.styled(.body))
                }
                Text(Bench.corpus[(index + 1) % Bench.corpus.count]).font(Extended.styled(.body, italic: true))
            }
            .padding()
        }
        .navigationTitle("Détail \(index)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@MainActor
struct ScenarioRunner {
    let model: ScenarioModel
    let monitor = FrameMonitor.shared

    func wait(_ s: Double) async { try? await Task.sleep(for: .seconds(s)) }

    func run() async {
        await wait(1.5)
        Extended.runMicro()

        // Nav title rendered with which font?
        if let l = Extended.label("Infomaniak") {
            print("NAVTITLE font=\(l.font.fontName) size=\(l.font.pointSize)")
            Bench.results["check_navtitle_custom_font"] = l.font.fontName.contains("Infomaniak") || l.font.fontName
                .contains("Inter") ? 1 : 0
        } else {
            Bench.results["check_navtitle_label_found"] = 0
        }

        // A. Push / pop navigation (nav bar title transitions).
        var state = Bench.signposter.beginInterval("uiPushPop")
        monitor.start()
        for i in 0 ..< 12 {
            model.path.append(i); await wait(0.6)
            model.path.removeLast(); await wait(0.6)
        }
        Extended.record("ui_pushpop", monitor.stop())
        Bench.signposter.endInterval("uiPushPop", state)

        // B. Tab switching (tab bar labels).
        state = Bench.signposter.beginInterval("uiTabs")
        monitor.start()
        for _ in 0 ..< 15 {
            model.tab = (model.tab + 1) % 3; await wait(0.4)
        }
        model.tab = 0
        await wait(0.5)
        Extended.record("ui_tabs", monitor.stop())
        Bench.signposter.endInterval("uiTabs", state)

        // C. Dynamic Type change while running.
        let window = Extended.window
        let sizeBefore = Extended.label("Infomaniak")?.font.pointSize ?? -1
        state = Bench.signposter.beginInterval("uiDynTypeChange")
        monitor.start()
        for i in 0 ..< 6 {
            window?.traitOverrides.preferredContentSizeCategory = i.isMultiple(of: 2) ? .accessibilityLarge : .large
            await wait(0.8)
        }
        window?.traitOverrides.preferredContentSizeCategory = .accessibilityLarge
        await wait(0.8)
        Extended.record("ui_dyntype_change", monitor.stop())
        Bench.signposter.endInterval("uiDynTypeChange", state)
        let sizeAfter = Extended.label("Infomaniak")?.font.pointSize ?? -1
        print("NAVTITLE size L=\(sizeBefore) AXL=\(sizeAfter)")
        Bench.results["check_navtitle_size_large"] = Double(sizeBefore)
        Bench.results["check_navtitle_size_ax_large"] = Double(sizeAfter)

        // D. Realistic screen scroll (images + mixed scripts + italic) at default size.
        window?.traitOverrides.preferredContentSizeCategory = .large
        await wait(1)
        state = Bench.signposter.beginInterval("uiFeedScroll")
        monitor.scrollView = window.flatMap { FrameMonitor.findScrollView(in: $0) }
        monitor.scrollSpeed = 3000
        monitor.start()
        await wait(8)
        monitor.scrollSpeed = 0
        Extended.record("ui_feed_scroll", monitor.stop())
        Bench.signposter.endInterval("uiFeedScroll", state)

        // E. Everything at once: accessibility size + scroll + push/pop + tabs.
        window?.traitOverrides.preferredContentSizeCategory = .accessibilityMedium
        await wait(1)
        state = Bench.signposter.beginInterval("uiAllAtOnce")
        monitor.start()
        for _ in 0 ..< 5 {
            monitor.scrollView = window.flatMap { FrameMonitor.findScrollView(in: $0) }
            monitor.scrollSpeed = 3000
            await wait(1.5)
            monitor.scrollSpeed = 0
            model.path.append(1); await wait(0.6)
            model.path.removeLast(); await wait(0.6)
            model.tab = 1; await wait(0.3)
            model.tab = 0; await wait(0.3)
        }
        Extended.record("ui_all_at_once", monitor.stop())
        Bench.signposter.endInterval("uiAllAtOnce", state)

        Bench.results["memory_end_mb"] = Extended.footprintMB()
        Bench.printResultsAndExit()
    }
}
