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

struct ComponentsView: View {
    @State private var flavor = Flavor.vanilla
    @State private var isOn = true
    @State private var quantity = 1
    @State private var text = ""
    @State private var date = Date.now
    @State private var isAlertPresented = false
    @State private var isConfirmationDialogPresented = false
    @State private var isSheetPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Controls") {
                    Picker("Segmented picker", selection: $flavor) {
                        ForEach(Flavor.allCases) { flavor in
                            Text(flavor.title).tag(flavor)
                        }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Toggle", isOn: $isOn)
                    Stepper("Stepper: \(quantity)", value: $quantity, in: 0 ... 10)
                    TextField("Text field", text: $text)
                    DatePicker("Date picker", selection: $date, displayedComponents: .date)

                    Picker("Menu picker", selection: $flavor) {
                        ForEach(Flavor.allCases) { flavor in
                            Text(flavor.title).tag(flavor)
                        }
                    }

                    LabeledContent("Labeled content", value: "Value")
                    Label("Label", systemImage: "star")
                    Button("Button") {}
                }

                Section("Navigation") {
                    NavigationLink("Inline navigation title") {
                        ComponentsDetailView()
                    }
                    Button("Sheet") { isSheetPresented = true }
                }

                Section {
                    Button("Alert") { isAlertPresented = true }
                    Button("Confirmation dialog") { isConfirmationDialogPresented = true }
                    Menu("Menu") {
                        Button("First action") {}
                        Button("Second action") {}
                    }
                } header: {
                    Text("System presentations")
                } footer: {
                    Text("Alerts, confirmation dialogs and menus are drawn by the system and keep the system font.")
                }
            }
            .navigationTitle("Components")
            .toolbar {
                ToolbarItem {
                    Button("Edit") {}
                }
            }
            .alert("Alert title", isPresented: $isAlertPresented) {
                Button("OK") {}
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            .confirmationDialog("Confirmation dialog", isPresented: $isConfirmationDialogPresented, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {}
            } message: {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            .sheet(isPresented: $isSheetPresented) {
                NavigationStack {
                    ComponentsDetailView()
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") { isSheetPresented = false }
                            }
                        }
                }
            }
        }
    }
}

private enum Flavor: String, CaseIterable, Identifiable {
    case vanilla
    case chocolate
    case strawberry

    var id: Self { self }

    var title: String { rawValue.capitalized }
}

private struct ComponentsDetailView: View {
    var body: some View {
        List {
            Section("Section header") {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                Text("Emphasized text")
                    .font(.mdEmphasized)
            }
        }
        .navigationTitle("Detail")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ComponentsView()
        .font(.md)
}
