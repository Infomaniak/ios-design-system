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

struct TypographySample: Identifiable {
    let name: String
    let style: ESDSTextStyle

    var id: String { name }
}

struct TypographySection: Identifiable {
    let title: String
    let samples: [TypographySample]

    var id: String { title }
}

extension TypographySection {
    static let all = [
        TypographySection(title: "Display", samples: [
            TypographySample(name: "6xl", style: .sixXl),
            TypographySample(name: "6xl Emphasized", style: .sixXlEmphasized),
            TypographySample(name: "5xl", style: .fiveXl),
            TypographySample(name: "5xl Emphasized", style: .fiveXlEmphasized),
            TypographySample(name: "4xl", style: .fourXl),
            TypographySample(name: "4xl Emphasized", style: .fourXlEmphasized)
        ]),
        TypographySection(title: "Headings", samples: [
            TypographySample(name: "3xl", style: .threeXl),
            TypographySample(name: "3xl Emphasized", style: .threeXlEmphasized),
            TypographySample(name: "2xl", style: .twoXl),
            TypographySample(name: "2xl Emphasized", style: .twoXlEmphasized),
            TypographySample(name: "xl", style: .xl),
            TypographySample(name: "xl Emphasized", style: .xlEmphasized)
        ]),
        TypographySection(title: "Body", samples: [
            TypographySample(name: "lg", style: .lg),
            TypographySample(name: "lg Emphasized", style: .lgEmphasized),
            TypographySample(name: "md", style: .md),
            TypographySample(name: "md Emphasized", style: .mdEmphasized)
        ]),
        TypographySection(title: "Small", samples: [
            TypographySample(name: "sm", style: .sm),
            TypographySample(name: "sm Emphasized", style: .smEmphasized),
            TypographySample(name: "xs", style: .xs),
            TypographySample(name: "xs Emphasized", style: .xsEmphasized)
        ])
    ]
}
