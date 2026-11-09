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
@testable import ESDSTypography
import Testing
#if canImport(UIKit)
import UIKit
#endif

struct InfomaniakSansTests {
    @Test(arguments: ["InfomaniakSans", "InfomaniakSansItalic"])
    func registersBundledFonts(postScriptName: String) {
        InfomaniakSans.register()
        InfomaniakSans.register()

        let font = CTFontCreateWithName(postScriptName as CFString, 17, nil)

        #expect(CTFontCopyPostScriptName(font) as String == postScriptName)
        #expect(CTFontCopyFamilyName(font) as String == InfomaniakSans.familyName)
    }

    #if canImport(UIKit)
    @Test(arguments: [
        (ESDSTextStyle.md, UILegibilityWeight.regular, 400.0),
        (.mdEmphasized, .regular, 500),
        (.md, .bold, 600),
        (.mdEmphasized, .bold, 700),
    ])
    func appliesWeightAndBoldText(style: ESDSTextStyle, legibilityWeight: UILegibilityWeight, expectedWeight: Double) {
        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(preferredContentSizeCategory: .large),
            UITraitCollection(legibilityWeight: legibilityWeight),
        ])

        let font = UIFont.infomaniakSans(style, compatibleWith: traits)

        // CoreText omits axes left at their default value, which is 400 for `wght`.
        let variation = CTFontCopyVariation(font as CTFont) as? [Int: Double]
        #expect(variation?[0x7767_6874] ?? 400 == expectedWeight)
        #expect(font.familyName == InfomaniakSans.familyName)
        #expect(font.pointSize == style.size)
    }

    @Test func scalesWithDynamicType() {
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)

        let font = UIFont.infomaniakSans(.md, compatibleWith: traits)

        #expect(font.pointSize > ESDSTextStyle.md.size)
    }
    #endif
}
