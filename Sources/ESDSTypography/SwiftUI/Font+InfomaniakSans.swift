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

public extension Font {
    /// Infomaniak Sans at `size`, scaled with Dynamic Type like `textStyle`.
    ///
    /// Custom fonts don't react to the Bold Text accessibility setting by themselves:
    /// prefer the `font(_:)` view modifier taking an ``ESDSTextStyle``, which does.
    static func infomaniakSans(
        size: CGFloat,
        weight: ESDSTextStyle.Weight = .regular,
        relativeTo textStyle: Font.TextStyle = .body
    ) -> Font {
        InfomaniakSans.register()
        return .custom(InfomaniakSans.familyName, size: size, relativeTo: textStyle).weight(weight.swiftUIWeight)
    }

    /// Infomaniak Sans for `style`, heavier when `legibilityWeight` is `.bold`.
    static func infomaniakSans(_ style: ESDSTextStyle, legibilityWeight: LegibilityWeight? = nil) -> Font {
        .infomaniakSans(
            size: style.size,
            weight: style.resolvedWeight(legibilityWeight: legibilityWeight),
            relativeTo: style.textStyle
        )
    }
}
