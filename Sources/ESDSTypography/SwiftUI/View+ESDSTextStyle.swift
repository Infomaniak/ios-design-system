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

struct ESDSTextStyleModifier: ViewModifier {
    @Environment(\.legibilityWeight) private var legibilityWeight
    @ScaledMetric private var lineSpacing: CGFloat

    let style: ESDSTextStyle

    init(style: ESDSTextStyle) {
        self.style = style
        _lineSpacing = ScaledMetric(wrappedValue: style.lineSpacing, relativeTo: style.textStyle)
    }

    func body(content: Content) -> some View {
        content
            .font(.infomaniakSans(style, legibilityWeight: legibilityWeight))
            .lineSpacing(lineSpacing)
    }
}

public extension View {
    /// Sets the default font of this view hierarchy to an Infomaniak Sans text style.
    ///
    /// The font scales with Dynamic Type, gets heavier when Bold Text is enabled and follows the style line height.
    /// Apply it at the root of the app so that every text without an explicit font uses Infomaniak Sans:
    ///
    /// ```swift
    /// WindowGroup {
    ///     ContentView()
    ///         .font(.md)
    /// }
    /// ```
    func font(_ style: ESDSTextStyle) -> some View {
        modifier(ESDSTextStyleModifier(style: style))
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: "6xl").font(.sixXl)
            Text(verbatim: "5xl").font(.fiveXl)
            Text(verbatim: "4xl").font(.fourXl)
            Text(verbatim: "3xl").font(.threeXl)
            Text(verbatim: "2xl").font(.twoXl)
            Text(verbatim: "xl emphasized").font(.xlEmphasized)
            Text(verbatim: "lg emphasized").font(.lgEmphasized)
            Text(verbatim: "md emphasized").font(.mdEmphasized)
            Text(verbatim: "md italic").italic()
            Text(verbatim: "sm").font(.sm)
            Text(verbatim: "xs").font(.xs)
            Text(verbatim: "Infomaniak Sans keeps long text readable, with the line height of the design system.")
        }
        .padding()
    }
    .font(.md)
}
