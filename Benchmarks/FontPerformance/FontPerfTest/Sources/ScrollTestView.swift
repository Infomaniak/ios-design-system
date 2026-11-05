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

import SwiftUI
import UIKit

struct ScrollStats {
    var frames = 0
    var hitches = 0
    var hitchRatio = 0.0
    var p50 = 0.0
    var p95 = 0.0
    var max = 0.0
}

/// Scrolls a List programmatically at constant speed and records frame pacing with CADisplayLink.
struct ScrollTestView: View {
    let onFinish: (ScrollStats) -> Void

    var body: some View {
        List(0 ..< Bench.corpus.count, id: \.self) { i in
            VStack(alignment: .leading, spacing: 2) {
                Text(Bench.corpus[i]).font(Bench.font(size: 17, weight: .semibold)).lineLimit(1)
                Text(Bench.corpus[(i * 7) % Bench.corpus.count] + " " + Bench.corpus[(i * 13) % Bench.corpus.count])
                    .font(Bench.font(size: 15, weight: .regular)).lineLimit(2)
                Text("#\(i) · \(Bench.corpus[(i * 3) % Bench.corpus.count].prefix(30))")
                    .font(Bench.font(size: 12, weight: .medium))
            }
        }
        .background(ScrollDriver(onFinish: onFinish))
    }
}

private struct ScrollDriver: UIViewRepresentable {
    let onFinish: (ScrollStats) -> Void

    func makeUIView(context: Context) -> DriverView { DriverView(onFinish: onFinish) }
    func updateUIView(_ uiView: DriverView, context: Context) {}

    final class DriverView: UIView {
        let onFinish: (ScrollStats) -> Void
        private var started = false

        init(onFinish: @escaping (ScrollStats) -> Void) {
            self.onFinish = onFinish
            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            guard window != nil, !started else { return }
            started = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self, let window = self.window else { return }
                let monitor = FrameMonitor.shared
                monitor.scrollView = FrameMonitor.findScrollView(in: window)
                monitor.scrollSpeed = 4000
                let state = Bench.signposter.beginInterval("scroll")
                monitor.start()
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    Bench.signposter.endInterval("scroll", state)
                    monitor.scrollSpeed = 0
                    self.onFinish(monitor.stop())
                }
            }
        }
    }
}

/// Records frame pacing (hitches) with CADisplayLink and can drive a scroll view at constant speed.
@MainActor
final class FrameMonitor: NSObject {
    static let shared = FrameMonitor()

    weak var scrollView: UIScrollView?
    var scrollSpeed: CGFloat = 0
    private var link: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var startTimestamp: CFTimeInterval = 0
    private var deltas: [Double] = []
    private var hitchTime = 0.0
    private var hitches = 0

    func start() {
        link?.invalidate()
        lastTimestamp = 0
        deltas = []
        hitchTime = 0
        hitches = 0
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 120, maximum: 120, preferred: 120)
        link.add(to: .main, forMode: .common)
        self.link = link
    }

    func stop() -> ScrollStats {
        link?.invalidate()
        link = nil
        let sorted = deltas.sorted()
        guard !sorted.isEmpty else { return ScrollStats() }
        let elapsed = max(lastTimestamp - startTimestamp, 0.001)
        return ScrollStats(
            frames: sorted.count,
            hitches: hitches,
            hitchRatio: hitchTime / elapsed,
            p50: sorted[sorted.count / 2],
            p95: sorted[Int(Double(sorted.count) * 0.95)],
            max: sorted.last ?? 0
        )
    }

    @objc private func tick(_ link: CADisplayLink) {
        let expected = link.targetTimestamp - link.timestamp
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            startTimestamp = link.timestamp
            return
        }
        let delta = link.timestamp - lastTimestamp
        lastTimestamp = link.timestamp
        deltas.append(delta * 1000)
        if delta > expected * 1.5 {
            hitches += 1
            hitchTime += (delta - expected) * 1000
        }
        if scrollSpeed > 0, let scrollView {
            var offset = scrollView.contentOffset
            offset.y += scrollSpeed * delta
            if offset.y > scrollView.contentSize.height - scrollView.bounds.height { offset.y = 0 }
            scrollView.contentOffset = offset
        }
    }

    /// Largest visible, scrollable scroll view in the window.
    static func findScrollView(in root: UIView) -> UIScrollView? {
        var best: UIScrollView?
        func visit(_ v: UIView) {
            if let s = v as? UIScrollView, !s.isHidden, s.window != nil,
               s.contentSize.height > s.bounds.height,
               s.convert(s.bounds, to: nil).intersects(s.window!.bounds),
               s.bounds.height > (best?.bounds.height ?? 0) {
                best = s
            }
            v.subviews.forEach(visit)
        }
        visit(root)
        return best
    }
}
