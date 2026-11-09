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

import ESDSTypography
import SwiftUI

struct TypographySampleRow: View {
    private static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

    let sample: TypographySample

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(caption)
                .font(.xs)
                .foregroundStyle(.secondary)

            Text(Self.loremIpsum)
                .font(sample.style)
        }
        .padding(.vertical, 4)
    }

    private var caption: String {
        let size = sample.style.size.formatted()
        guard let lineHeight = sample.style.lineHeight else { return "\(sample.name) · \(size) pt" }
        return "\(sample.name) · \(size)/\(lineHeight.formatted()) pt"
    }
}

#Preview {
    List {
        TypographySampleRow(sample: TypographySection.all[0].samples[0])
    }
}
