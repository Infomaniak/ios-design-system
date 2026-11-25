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
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit

extension NSFont.TextStyle {
    init(_ textStyle: Font.TextStyle) {
        self = switch textStyle {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .subheadline: .subheadline
        case .callout: .callout
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        default: .body
        }
    }
}
#endif

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

    /// Infomaniak Sans at the iOS default size of `textStyle` (Dynamic Type `large`), with the natural line height.
    public init(weight: Weight = .regular, relativeTo textStyle: Font.TextStyle) {
        self.init(size: Self.systemSize(of: textStyle), weight: weight, relativeTo: textStyle)
    }

    /// The Infomaniak Sans equivalent of a system text style, with the system default size and weight.
    public init(_ textStyle: Font.TextStyle) {
        self.init(weight: textStyle == .headline ? .semibold : .regular, relativeTo: textStyle)
    }

    /// Point size of the system font for `textStyle` at the default content size category.
    static func systemSize(of textStyle: Font.TextStyle) -> CGFloat {
        #if canImport(UIKit)
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        return UIFont.preferredFont(forTextStyle: UIFont.TextStyle(textStyle), compatibleWith: traits).pointSize
        #elseif canImport(AppKit)
        return NSFont.preferredFont(forTextStyle: NSFont.TextStyle(textStyle)).pointSize
        #endif
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

// Names mirror `typography.tokens.json` of the Infomaniak design system;
// sizes follow the system font of the matching text style.
public extension ESDSTextStyle {
    static let xs = ESDSTextStyle(relativeTo: .caption)
    static let xsEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .caption)
    static let sm = ESDSTextStyle(relativeTo: .subheadline)
    static let smEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .subheadline)
    static let md = ESDSTextStyle(relativeTo: .body)
    static let mdEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .body)
    static let lg = ESDSTextStyle(relativeTo: .body)
    static let lgEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .body)
    static let xl = ESDSTextStyle(relativeTo: .title3)
    static let xlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .title3)
    static let twoXl = ESDSTextStyle(relativeTo: .title2)
    static let twoXlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .title2)
    static let threeXl = ESDSTextStyle(relativeTo: .title)
    static let threeXlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .title)
    static let fourXl = ESDSTextStyle(relativeTo: .largeTitle)
    static let fourXlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .largeTitle)
    static let fiveXl = ESDSTextStyle(relativeTo: .largeTitle)
    static let fiveXlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .largeTitle)
    static let sixXl = ESDSTextStyle(relativeTo: .largeTitle)
    static let sixXlEmphasized = ESDSTextStyle(weight: .medium, relativeTo: .largeTitle)
}
