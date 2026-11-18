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

struct TextEntrySection: View {
    @State private var text = ""
    @State private var promptedText = ""
    @State private var multilineText = ""
    @State private var secret = ""
    @State private var notes = "TextEditor: Lorem ipsum dolor sit amet, consectetur adipiscing elit."

    var body: some View {
        Section("Text entry") {
            ShowcaseRow("TextField") {
                TextField("Placeholder", text: $text)
            }
            ShowcaseRow("TextField with prompt") {
                TextField("Title", text: $promptedText, prompt: Text("Prompt text"))
            }
            ShowcaseRow("TextField axis: .vertical") {
                TextField("Multiline placeholder", text: $multilineText, axis: .vertical)
                    .lineLimit(2 ... 4)
            }
            ShowcaseRow("SecureField") {
                SecureField("Password", text: $secret)
            }
            ShowcaseRow("TextEditor") {
                TextEditor(text: $notes)
                    .frame(minHeight: 80)
            }
        }
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Previous") {}
                Spacer()
                Button("Keyboard toolbar") {}
            }
        }
        #endif
    }
}

struct ToggleSection: View {
    @State private var isOn = true

    var body: some View {
        Section("Toggles") {
            Toggle("Toggle .switch", isOn: $isOn)
                .toggleStyle(.switch)
            Toggle("Toggle with label", systemImage: "bell", isOn: $isOn)
            ShowcaseRow(".toggleStyle(.button)") {
                Toggle("Button toggle", isOn: $isOn)
                    .toggleStyle(.button)
            }
            #if os(macOS)
            Toggle("Toggle .checkbox", isOn: $isOn)
                .toggleStyle(.checkbox)
            #endif
        }
    }
}

struct ValueControlSection: View {
    @State private var quantity = 1
    @State private var volume = 40.0

    var body: some View {
        Section("Value controls") {
            Stepper("Stepper: \(quantity)", value: $quantity, in: 0 ... 10)
            ShowcaseRow("Slider with labels") {
                Slider(value: $volume, in: 0 ... 100, step: 10) {
                    Text("Volume")
                } minimumValueLabel: {
                    Text("Min")
                } maximumValueLabel: {
                    Text("Max")
                }
            }
            LabeledContent("Slider in LabeledContent") {
                Slider(value: $volume, in: 0 ... 100)
            }
        }
    }
}
