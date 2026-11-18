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

struct ButtonStyleSection: View {
    var body: some View {
        Section("Button styles") {
            ShowcaseRow("Button (no style)") {
                Button("Automatic") {}
            }
            ButtonStyleRow(name: "automatic", style: .automatic)
            ButtonStyleRow(name: "bordered", style: .bordered)
            ButtonStyleRow(name: "borderedProminent", style: .borderedProminent)
            ButtonStyleRow(name: "borderless", style: .borderless)
            ButtonStyleRow(name: "plain", style: .plain)
            ButtonStyleRow(name: "glass", style: .glass)
            ButtonStyleRow(name: "glassProminent", style: .glassProminent)
        }
    }
}

private struct ButtonStyleRow<Style: PrimitiveButtonStyle>: View {
    let name: String
    let style: Style

    var body: some View {
        ShowcaseRow(".buttonStyle(.\(name))") {
            HStack {
                Button("Button") {}
                Button("Button", systemImage: "star") {}
            }
            .buttonStyle(style)
        }
    }
}

struct ControlSizeSection: View {
    var body: some View {
        Section("Control sizes") {
            ForEach(ControlSize.allCases, id: \.self) { controlSize in
                ShowcaseRow(".controlSize(.\(String(describing: controlSize)))") {
                    HStack {
                        Button("Bordered") {}
                            .buttonStyle(.bordered)
                        Button("Prominent") {}
                            .buttonStyle(.borderedProminent)
                        Button("Glass") {}
                            .buttonStyle(.glass)
                    }
                    .controlSize(controlSize)
                }
            }
        }
    }
}

struct ButtonRoleSection: View {
    var body: some View {
        Section("Button roles") {
            ShowcaseRow("role: .destructive") {
                HStack {
                    Button("Delete", role: .destructive) {}
                    Button("Delete", role: .destructive) {}
                        .buttonStyle(.borderedProminent)
                }
            }
            ShowcaseRow("role: .cancel") {
                HStack {
                    Button("Cancel", role: .cancel) {}
                    Button("Cancel", role: .cancel) {}
                        .buttonStyle(.bordered)
                }
            }
            ShowcaseRow("role: .confirm / .close") {
                HStack {
                    Button("Confirm", role: .confirm) {}
                        .buttonStyle(.glassProminent)
                    Button("Close", role: .close) {}
                        .buttonStyle(.glass)
                }
            }
        }
    }
}

struct SystemButtonSection: View {
    private static let infomaniakURL = URL(string: "https://www.infomaniak.com")

    var body: some View {
        Section("System buttons") {
            if let url = Self.infomaniakURL {
                ShowcaseRow("Link") {
                    Link("Visit infomaniak.com", destination: url)
                }
                ShowcaseRow("ShareLink") {
                    ShareLink("Share link", item: url)
                }
            }
            #if os(iOS)
            ShowcaseRow("EditButton") {
                EditButton()
            }
            #endif
            ShowcaseRow("PasteButton") {
                PasteButton(payloadType: String.self) { _ in }
            }
            ShowcaseRow("RenameButton") {
                RenameButton()
                    .renameAction {}
            }
        }
    }
}
