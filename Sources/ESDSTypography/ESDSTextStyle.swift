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

/// A typography preset of the design system, rendered with ``InfomaniakSans``.
///
/// Sizes are the default ones (Dynamic Type `large`); they scale like `textStyle` when the user changes the text size.
public struct ESDSTextStyle: Hashable, Sendable {
    public let size: CGFloat
    public let weight: Weight
    /// Distance between baselines, `nil` to use the natural line height of the font.
    public let lineHeight: CGFloat?
    /// The system text style the size scales with.
    public let textStyle: Font.TextStyle
    /// Extra spacing to add between lines so that baselines are `lineHeight` apart.
    let lineSpacing: CGFloat

    public init(size: CGFloat, weight: Weight = .regular, lineHeight: CGFloat? = nil, relativeTo textStyle: Font.TextStyle) {
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
        self.textStyle = textStyle
        lineSpacing = Self.lineSpacing(size: size, lineHeight: lineHeight)
    }

    /// The Infomaniak Sans equivalent of a system text style, with the iOS default size and weight.
    public init(_ textStyle: Font.TextStyle) {
        let metrics: (size: CGFloat, weight: Weight) = switch textStyle {
        case .largeTitle: (34, .regular)
        case .title: (28, .regular)
        case .title2: (22, .regular)
        case .title3: (20, .regular)
        case .headline: (17, .semibold)
        case .callout: (16, .regular)
        case .subheadline: (15, .regular)
        case .footnote: (13, .regular)
        case .caption: (12, .regular)
        case .caption2: (11, .regular)
        default: (17, .regular)
        }
        self.init(size: metrics.size, weight: metrics.weight, relativeTo: textStyle)
    }

    private static func lineSpacing(size: CGFloat, lineHeight: CGFloat?) -> CGFloat {
        guard let lineHeight else { return 0 }
        InfomaniakSans.register()
        let font = CTFontCreateWithName(InfomaniakSans.postScriptName as CFString, size, nil)
        let naturalLineHeight = CTFontGetAscent(font) + CTFontGetDescent(font) + CTFontGetLeading(font)
        return max(0, lineHeight - naturalLineHeight)
    }

    func resolvedWeight(legibilityWeight: LegibilityWeight?) -> Weight {
        legibilityWeight == .bold ? weight.accessibilityBold : weight
    }
}

// MARK: - Weight

public extension ESDSTextStyle {
    /// A position on the `wght` axis of the variable font, from 100 to 900.
    struct Weight: Hashable, Sendable, Comparable {
        public static let thin = Weight(100)
        public static let ultraLight = Weight(200)
        public static let light = Weight(300)
        public static let regular = Weight(400)
        public static let medium = Weight(500)
        public static let semibold = Weight(600)
        public static let bold = Weight(700)
        public static let heavy = Weight(800)
        public static let black = Weight(900)

        public let value: CGFloat

        public init(_ value: CGFloat) {
            self.value = min(max(value, 100), 900)
        }

        /// The heavier weight used when the user enables Bold Text, like system fonts do.
        public var accessibilityBold: Weight {
            Weight(value + 200)
        }

        var swiftUIWeight: Font.Weight {
            switch value {
            case ..<150: .thin
            case ..<250: .ultraLight
            case ..<350: .light
            case ..<450: .regular
            case ..<550: .medium
            case ..<650: .semibold
            case ..<750: .bold
            case ..<850: .heavy
            default: .black
            }
        }

        public static func < (lhs: Weight, rhs: Weight) -> Bool {
            lhs.value < rhs.value
        }
    }
}

// MARK: - Design tokens

// Mirrors `typography.tokens.json` of the Infomaniak design system.
public extension ESDSTextStyle {
    static let xs = ESDSTextStyle(size: 12, lineHeight: 16, relativeTo: .caption)
    static let xsEmphasized = ESDSTextStyle(size: 12, weight: .medium, lineHeight: 16, relativeTo: .caption)
    static let sm = ESDSTextStyle(size: 14, lineHeight: 20, relativeTo: .subheadline)
    static let smEmphasized = ESDSTextStyle(size: 14, weight: .medium, lineHeight: 20, relativeTo: .subheadline)
    static let md = ESDSTextStyle(size: 16, lineHeight: 24, relativeTo: .body)
    static let mdEmphasized = ESDSTextStyle(size: 16, weight: .medium, lineHeight: 24, relativeTo: .body)
    static let lg = ESDSTextStyle(size: 18, lineHeight: 26, relativeTo: .body)
    static let lgEmphasized = ESDSTextStyle(size: 18, weight: .medium, lineHeight: 26, relativeTo: .body)
    static let xl = ESDSTextStyle(size: 20, lineHeight: 28, relativeTo: .title3)
    static let xlEmphasized = ESDSTextStyle(size: 20, weight: .medium, lineHeight: 28, relativeTo: .title3)
    static let twoXl = ESDSTextStyle(size: 24, lineHeight: 32, relativeTo: .title2)
    static let twoXlEmphasized = ESDSTextStyle(size: 24, weight: .medium, lineHeight: 32, relativeTo: .title2)
    static let threeXl = ESDSTextStyle(size: 32, lineHeight: 40, relativeTo: .title)
    static let threeXlEmphasized = ESDSTextStyle(size: 32, weight: .medium, lineHeight: 40, relativeTo: .title)
    static let fourXl = ESDSTextStyle(size: 40, lineHeight: 48, relativeTo: .largeTitle)
    static let fourXlEmphasized = ESDSTextStyle(size: 40, weight: .medium, lineHeight: 48, relativeTo: .largeTitle)
    static let fiveXl = ESDSTextStyle(size: 48, lineHeight: 56, relativeTo: .largeTitle)
    static let fiveXlEmphasized = ESDSTextStyle(size: 48, weight: .medium, lineHeight: 56, relativeTo: .largeTitle)
    static let sixXl = ESDSTextStyle(size: 52, lineHeight: 60, relativeTo: .largeTitle)
    static let sixXlEmphasized = ESDSTextStyle(size: 52, weight: .medium, lineHeight: 60, relativeTo: .largeTitle)
}
