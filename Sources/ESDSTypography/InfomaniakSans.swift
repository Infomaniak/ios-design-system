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
import Foundation
import OSLog

/// The Infomaniak Sans variable font (weight 100–900, automatic optical size), shipped with this package.
///
/// The font is registered for the current process the first time any `infomaniakSans` font is created,
/// so apps don't need to declare it in `UIAppFonts`. Call ``register()`` explicitly only if the font
/// must be available before that, for example when it is referenced by name from web content.
public enum InfomaniakSans {
    public static let familyName = "Infomaniak Sans"
    static let postScriptName = "InfomaniakSans"

    private static let logger = Logger(subsystem: "com.infomaniak.esds", category: "InfomaniakSans")

    private static let registration: Void = {
        let urls = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: "Fonts") ?? []
        assert(!urls.isEmpty, "Infomaniak Sans font files are missing from the ESDSTypography bundle")

        for url in urls {
            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
                continue
            }
            guard let error = error?.takeRetainedValue(),
                  CFErrorGetCode(error) != CTFontManagerError.alreadyRegistered.rawValue else {
                continue
            }
            let reason = (error as Error).localizedDescription
            logger.error("Failed to register \(url.lastPathComponent, privacy: .public): \(reason, privacy: .public)")
        }
    }()

    /// Registers the font files for the current process. Safe to call several times and from any thread.
    public static func register() {
        _ = registration
    }

    /// Value of the `wght` variation axis matching a CSS-like weight (100–900).
    static func variation(weight: CGFloat) -> [Int: CGFloat] {
        let wghtAxisTag = 0x7767_6874
        return [wghtAxisTag: weight]
    }
}
