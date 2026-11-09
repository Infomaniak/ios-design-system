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

#if canImport(UIKit)
import SwiftUI
import UIKit

public extension UIFont {
    /// Infomaniak Sans for `style`, scaled for the content size category and heavier when Bold Text is enabled.
    ///
    /// Without `traitCollection`, the current trait collection is used.
    /// Set `adjustsFontForContentSizeCategory` on labels so that they follow later text size changes.
    static func infomaniakSans(_ style: ESDSTextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        let legibilityWeight = (traitCollection ?? .current).legibilityWeight
        return infomaniakSans(style, compatibleWith: traitCollection, isBoldTextEnabled: legibilityWeight == .bold)
    }

    internal static func infomaniakSans(
        _ style: ESDSTextStyle,
        compatibleWith traitCollection: UITraitCollection?,
        isBoldTextEnabled: Bool
    ) -> UIFont {
        InfomaniakSans.register()
        let weight = style.resolvedWeight(legibilityWeight: isBoldTextEnabled ? .bold : .regular)
        let variationAttribute = UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String)
        let descriptor = UIFontDescriptor(fontAttributes: [
            .name: InfomaniakSans.postScriptName,
            variationAttribute: InfomaniakSans.variation(weight: weight.value)
        ])
        let font = UIFont(descriptor: descriptor, size: style.size)
        return UIFontMetrics(forTextStyle: UIFont.TextStyle(style.textStyle))
            .scaledFont(for: font, compatibleWith: traitCollection)
    }
}

extension UIFont.TextStyle {
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
