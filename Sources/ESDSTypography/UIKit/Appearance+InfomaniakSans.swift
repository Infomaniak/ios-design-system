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
import UIKit

public extension InfomaniakSans {
    /// Uses Infomaniak Sans in the system bars and controls that SwiftUI renders with UIKit:
    /// navigation titles, bar buttons, tab bar items and segmented pickers.
    ///
    /// Call it once at launch, before any bar is displayed, for example in the `init` of your `App`.
    /// Only fonts are changed, so bars keep their system background and Liquid Glass style.
    /// Alerts, menus, and system sheets always use the system font.
    @MainActor
    static func applyToSystemAppearance() {
        // Bars are configured before any trait collection is available, so read the setting directly.
        let font = { (style: ESDSTextStyle) in
            UIFont.infomaniakSans(style, compatibleWith: nil, isBoldTextEnabled: UIAccessibility.isBoldTextEnabled)
        }

        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [.font: font(ESDSTextStyle(.headline))]
        navigationBar.largeTitleTextAttributes = [
            .font: font(ESDSTextStyle(size: 34, weight: .bold, relativeTo: .largeTitle))
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([.font: font(ESDSTextStyle(.body))], for: .normal)

        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: font(ESDSTextStyle(size: 10, weight: .medium, relativeTo: .caption2))],
            for: .normal
        )

        let segmentedControl = UISegmentedControl.appearance()
        segmentedControl.setTitleTextAttributes([.font: font(ESDSTextStyle(.footnote))], for: .normal)
        segmentedControl.setTitleTextAttributes(
            [.font: font(ESDSTextStyle(size: 13, weight: .semibold, relativeTo: .footnote))],
            for: .selected
        )
    }
}
#endif
