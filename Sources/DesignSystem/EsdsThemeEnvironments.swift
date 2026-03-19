//
//  ESDSThemeEnvironments.swift
//  iOSDesignSystem
//
//  Created by Jordan on 18.03.2026.
//

import SwiftUI

public struct ESDSTheme: Sendable {
    static let infomaniak = ESDSTheme() // TODO: Remove when the generated ones come
}

private struct ESDSThemeKey: EnvironmentKey {
    static let defaultValue: ESDSTheme = .infomaniak
}

public extension EnvironmentValues {
    var esdsTheme: ESDSTheme {
        get { self[ESDSThemeKey.self] }
        set { self[ESDSThemeKey.self] = newValue }
    }
}

public extension View {
    func esdsTheme(_ theme: ESDSTheme) -> some View {
        environment(\.esdsTheme, theme)
    }
}
