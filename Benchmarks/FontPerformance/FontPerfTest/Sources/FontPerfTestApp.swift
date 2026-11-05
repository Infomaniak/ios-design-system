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

@main
struct FontPerfTestApp: App {
    init() {
        Bench.registerIfNeeded()
        if Bench.suite == "extended" {
            Extended.configureAppearance()
        }
    }

    var body: some Scene {
        WindowGroup {
            if Bench.suite == "extended" {
                ExtendedRootView()
            } else {
                RootView()
            }
        }
    }
}

struct RootView: View {
    @State private var showScroll = false

    var body: some View {
        Group {
            if showScroll {
                ScrollTestView {
                    Bench.finish(scroll: $0)
                }
            } else {
                Text("Benchmarks…").font(Bench.font(size: 17, weight: .regular))
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            Bench.runMicroBenchmarks()
            showScroll = true
        }
    }
}
