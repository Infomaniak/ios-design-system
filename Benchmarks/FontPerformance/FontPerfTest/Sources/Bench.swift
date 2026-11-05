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
import os
import SwiftUI
import UIKit

enum FontKind: String { case sf, ims }

@MainActor
enum Bench {
    static let kind = FontKind(rawValue: UserDefaults.standard.string(forKey: "font") ?? "sf") ?? .sf
    static let suite = UserDefaults.standard.string(forKey: "suite") ?? "micro"
    static let signposter = OSSignposter(subsystem: "FontPerf", category: .pointsOfInterest)
    static var results: [String: Double] = [:]

    static let sizes: [CGFloat] = [34, 28, 22, 20, 17, 16, 15, 13, 12, 11]
    struct Weight {
        let swiftUI: Font.Weight
        let uiKit: UIFont.Weight
        let wght: CGFloat
    }

    static let weights: [Weight] = [
        Weight(swiftUI: .regular, uiKit: .regular, wght: 400),
        Weight(swiftUI: .medium, uiKit: .medium, wght: 500),
        Weight(swiftUI: .semibold, uiKit: .semibold, wght: 600),
        Weight(swiftUI: .bold, uiKit: .bold, wght: 700)
    ]

    static let corpus: [String] = {
        let words = """
        Infomaniak kDrive kMail Swiss Transfer cloud données sécurisées partage fichiers collaboratif \
        écologique Genève hébergement serveur synchronisation calendrier contacts rapide fiable \
        The quick brown fox jumps over the lazy dog 0123456789 éàèùç ÉÀ ß œ æ «» — … € @ # % & ?
        """.split(separator: " ").map(String.init)
        var rng = SplitMix(seed: 42)
        return (0 ..< 2000).map { _ in
            let count = Int(rng.next() % 18) + 2
            return (0 ..< count).map { _ in words[Int(rng.next() % UInt64(words.count))] }.joined(separator: " ")
        }
    }()

    // MARK: Fonts

    static func registerIfNeeded() {
        guard kind == .ims else { return }
        let urls = ["infomaniak-sans.variable.normal", "infomaniak-sans.variable.italic"]
            .compactMap { Bundle.main.url(forResource: $0, withExtension: "ttf") }
        precondition(urls.count == 2, "Fonts missing from bundle")
        let state = signposter.beginInterval("register")
        let elapsed = ContinuousClock().measure {
            for url in urls {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }
        }
        signposter.endInterval("register", state)
        results["register_ms"] = elapsed.ms
    }

    static func font(size: CGFloat, weight: Font.Weight) -> Font {
        switch kind {
        case .sf: return .system(size: size, weight: weight)
        case .ims: return .custom("Infomaniak Sans", size: size).weight(weight)
        }
    }

    static func ctFont(size: CGFloat, weight: UIFont.Weight, wght: CGFloat) -> CTFont {
        switch kind {
        case .sf:
            return UIFont.systemFont(ofSize: size, weight: weight) as CTFont
        case .ims:
            let wghtTag = 0x7767_6874
            let desc = CTFontDescriptorCreateWithAttributes([
                kCTFontNameAttribute: "InfomaniakSans",
                kCTFontVariationAttribute: [wghtTag: wght]
            ] as CFDictionary)
            return CTFontCreateWithFontDescriptor(desc, size, nil)
        }
    }

    // MARK: Benchmarks

    static func runMicroBenchmarks() {
        results["first_use_ms"] = measure("firstUse") {
            let font = ctFont(size: 17, weight: .regular, wght: 400)
            let line = CTLineCreateWithAttributedString(NSAttributedString(string: "Hello Infomaniak", attributes: [.font: font]))
            _ = CTLineGetTypographicBounds(line, nil, nil, nil)
        }

        results["font_creation_cold_ms"] = measure("fontCreationCold") { _ = allCTFonts() }
        results["font_creation_warm_ms"] = measure("fontCreationWarm") { _ = allCTFonts() }

        let fonts = allCTFonts()
        let attributed = corpus.enumerated().map { i, s in
            NSAttributedString(string: s, attributes: [.font: fonts[i % fonts.count]])
        }

        results["ct_layout_cold_ms"] = measure("ctLayoutCold") { layout(attributed) }
        results["ct_layout_warm_ms"] = median((0 ..< 7).map { _ in measure("ctLayoutWarm") { layout(attributed) } })

        let lines = attributed.map { CTLineCreateWithAttributedString($0) }
        let ctx = CGContext(data: nil, width: 2400, height: 120, bitsPerComponent: 8, bytesPerRow: 0,
                            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.scaleBy(x: 3, y: 3)
        results["raster_cold_ms"] = measure("rasterCold") { draw(lines, in: ctx) }
        results["raster_warm_ms"] = median((0 ..< 7).map { _ in measure("rasterWarm") { draw(lines, in: ctx) } })

        results["swiftui_render_cold_ms"] = measure("swiftUIRenderCold") { renderSwiftUI(offset: 0) }
        results["swiftui_render_warm_ms"] = median((1 ... 10).map { i in
            measure("swiftUIRenderWarm") { renderSwiftUI(offset: i * 200) }
        })

        results["weight_applied"] = weightApplied() ? 1 : 0
    }

    static func finish(scroll: ScrollStats) {
        results["scroll_frames"] = Double(scroll.frames)
        results["scroll_hitch_ratio_ms_per_s"] = scroll.hitchRatio
        results["scroll_frame_p50_ms"] = scroll.p50
        results["scroll_frame_p95_ms"] = scroll.p95
        results["scroll_frame_max_ms"] = scroll.max
        results["scroll_hitches"] = Double(scroll.hitches)
        printResultsAndExit()
    }

    static func printResultsAndExit() {
        let json = (try? JSONSerialization.data(withJSONObject: results, options: [.sortedKeys])) ?? Data()
        print("RESULT \(kind.rawValue) \(String(data: json, encoding: .utf8)!)")
        fflush(stdout)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
    }

    // MARK: Helpers

    private static func allCTFonts() -> [CTFont] {
        sizes.flatMap { size in weights.map { ctFont(size: size, weight: $0.uiKit, wght: $0.wght) } }
    }

    static func layout(_ strings: [NSAttributedString]) {
        var total = 0.0
        for s in strings {
            let line = CTLineCreateWithAttributedString(s)
            total += CTLineGetTypographicBounds(line, nil, nil, nil)
        }
        precondition(total > 0)
    }

    private static func draw(_ lines: [CTLine], in ctx: CGContext) {
        for line in lines {
            ctx.clear(CGRect(x: 0, y: 0, width: 800, height: 40))
            ctx.textPosition = CGPoint(x: 0, y: 8)
            CTLineDraw(line, ctx)
        }
    }

    private static func renderSwiftUI(offset: Int) {
        let view = VStack(alignment: .leading, spacing: 4) {
            ForEach(0 ..< 200, id: \.self) { i in
                Text(corpus[(offset + i) % corpus.count])
                    .font(font(size: sizes[i % sizes.count], weight: weights[i % weights.count].swiftUI))
            }
        }
        .frame(width: 390)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3
        precondition(renderer.cgImage != nil)
    }

    private static func weightApplied() -> Bool {
        func width(_ w: Font.Weight) -> CGFloat {
            let r = ImageRenderer(content: Text("Hamburgefonstiv WWW").font(font(size: 40, weight: w)).fixedSize())
            return r.uiImage?.size.width ?? 0
        }
        let regular = width(.regular), black = width(.black)
        print("WEIGHT \(kind.rawValue) regular=\(regular) black=\(black)")
        return black > regular + 1
    }

    @discardableResult
    static func measure(_ name: StaticString, _ block: () -> Void) -> Double {
        let state = signposter.beginInterval(name)
        let d = ContinuousClock().measure(block)
        signposter.endInterval(name, state)
        return d.ms
    }

    static func median(_ values: [Double]) -> Double {
        values.sorted()[values.count / 2]
    }
}

struct SplitMix {
    var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

extension Duration {
    var ms: Double {
        Double(components.seconds) * 1000 + Double(components.attoseconds) / 1e15
    }
}
