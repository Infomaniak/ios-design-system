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

struct ESDSRadiusModifier: ViewModifier {
    @Environment(\.esdsTheme) private var theme

    let value: KeyPath<ESDSTheme.Radius, RoundedRectangle>

    func body(content: Content) -> some View {
        content
            .clipShape(theme.radius[keyPath: value])
    }
}

public extension View {
    func radius(value: KeyPath<ESDSTheme.Radius, RoundedRectangle>) -> some View {
        modifier(ESDSRadiusModifier(value: value))
    }
}
