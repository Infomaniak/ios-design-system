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

enum Flavor: String, CaseIterable, Identifiable {
    case vanilla
    case chocolate
    case strawberry

    var id: Self { self }

    var title: String { rawValue.capitalized }
}

struct PickerStyleSection: View {
    @State private var flavor = Flavor.vanilla

    var body: some View {
        Section("Picker styles") {
            FlavorPicker(title: "Automatic picker", selection: $flavor)
            ShowcaseRow(".pickerStyle(.segmented)") {
                FlavorPicker(title: "Segmented picker", selection: $flavor)
                    .pickerStyle(.segmented)
            }
            FlavorPicker(title: "Menu picker", selection: $flavor)
                .pickerStyle(.menu)
            ShowcaseRow(".pickerStyle(.palette)") {
                FlavorPicker(title: "Palette picker", selection: $flavor)
                    .pickerStyle(.palette)
            }
            #if os(iOS)
            FlavorPicker(title: "Navigation link picker", selection: $flavor)
                .pickerStyle(.navigationLink)
            ShowcaseRow(".pickerStyle(.wheel)") {
                FlavorPicker(title: "Wheel picker", selection: $flavor)
                    .pickerStyle(.wheel)
                    .frame(height: 120)
            }
            #endif
            #if os(macOS)
            FlavorPicker(title: "Radio group picker", selection: $flavor)
                .pickerStyle(.radioGroup)
            #endif
        }
    }
}

struct InlinePickerSection: View {
    @State private var flavor = Flavor.chocolate

    var body: some View {
        Section("Picker · .inline") {
            FlavorPicker(title: "Inline picker", selection: $flavor)
                .pickerStyle(.inline)
                .labelsHidden()
        }
    }
}

private struct FlavorPicker: View {
    let title: String
    @Binding var selection: Flavor

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(Flavor.allCases) { flavor in
                Text(flavor.title).tag(flavor)
            }
        }
    }
}

struct DateAndColorSection: View {
    @State private var date = Date.now
    @State private var color = Color.blue
    #if os(iOS)
    @State private var dates = Set<DateComponents>()
    #endif

    var body: some View {
        Section("Date & color") {
            DatePicker("Date picker .compact", selection: $date)
                .datePickerStyle(.compact)
            ShowcaseRow(".datePickerStyle(.graphical)") {
                DatePicker("Graphical date picker", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            #if os(iOS)
            ShowcaseRow(".datePickerStyle(.wheel)") {
                DatePicker("Wheel date picker", selection: $date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            ShowcaseRow("MultiDatePicker") {
                MultiDatePicker("Multi date picker", selection: $dates)
            }
            #else
            DatePicker("Date picker .field", selection: $date)
                .datePickerStyle(.field)
            #endif
            ColorPicker("Color picker", selection: $color)
        }
    }
}
