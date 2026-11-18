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

struct PresentationsShowcaseView: View {
    @State private var isAlertPresented = false
    @State private var isConfirmationDialogPresented = false
    @State private var isSheetPresented = false
    @State private var isPopoverPresented = false
    @State private var isFullScreenCoverPresented = false
    @State private var isInspectorPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Modal presentations") {
                    Button("Alert") { isAlertPresented = true }
                    Button("Confirmation dialog") { isConfirmationDialogPresented = true }
                    Button("Sheet") { isSheetPresented = true }
                    Button("Popover") { isPopoverPresented = true }
                        .popover(isPresented: $isPopoverPresented) {
                            Text("Popover content")
                                .padding()
                                .presentationCompactAdaptation(.popover)
                        }
                    #if os(iOS)
                    Button("Full screen cover") { isFullScreenCoverPresented = true }
                    #endif
                    Button("Inspector") { isInspectorPresented.toggle() }
                }
                MenuSection()
                Section("Navigation") {
                    NavigationLink("Inline navigation title") {
                        InlineTitleDetailView()
                    }
                }
            }
            .navigationTitle("Presentations")
            #if os(iOS)
                .toolbarTitleDisplayMode(.inline)
            #endif
                .toolbar { PresentationsToolbar() }
                .alert("Alert title", isPresented: $isAlertPresented) {
                    Button("OK") {}
                    Button("Delete", role: .destructive) {}
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Alert message: lorem ipsum dolor sit amet.")
                }
                .confirmationDialog(
                    "Confirmation dialog",
                    isPresented: $isConfirmationDialogPresented,
                    titleVisibility: .visible
                ) {
                    Button("Archive") {}
                    Button("Delete", role: .destructive) {}
                } message: {
                    Text("Confirmation dialog message")
                }
                .sheet(isPresented: $isSheetPresented) {
                    PresentedContentView(title: "Sheet")
                        .presentationDetents([.medium, .large])
                }
            #if os(iOS)
                .fullScreenCover(isPresented: $isFullScreenCoverPresented) {
                    PresentedContentView(title: "Full screen cover")
                }
            #endif
                .inspector(isPresented: $isInspectorPresented) {
                    InspectorContentView()
                }
        }
    }
}

private struct PresentationsToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Principal title")
                Text("Toolbar principal item")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        ToolbarItem(placement: .cancellationAction) {
            Button("Text button") {}
        }
        ToolbarItem(placement: .primaryAction) {
            Menu("Menu") {
                Button("Toolbar menu action") {}
            }
        }
    }
}

private struct MenuSection: View {
    @State private var sort = "Name"

    var body: some View {
        Section("Menus & tooltips") {
            Menu("Menu") {
                Section("Menu section") {
                    Button("Action", systemImage: "star") {}
                    Button("Delete", systemImage: "trash", role: .destructive) {}
                }
                Picker("Sort by", selection: $sort) {
                    ForEach(["Name", "Date", "Size"], id: \.self) { Text($0) }
                }
                Menu("Submenu") {
                    Button("Nested action") {}
                }
            }
            Menu("Menu with primary action") {
                Button("Secondary action") {}
            } primaryAction: {}
            Text("Long press me: contextMenu")
                .contextMenu {
                    Button("Copy", systemImage: "doc.on.doc") {}
                    Button("Delete", systemImage: "trash", role: .destructive) {}
                }
            Button("Button with .help tooltip") {}
                .help("Tooltip from .help")
        }
    }
}

private struct PresentedContentView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String

    var body: some View {
        NavigationStack {
            Form {
                Section("Presented section header") {
                    Text("Presented content inherits the environment font.")
                    Button("Button in presentation") {}
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct InspectorContentView: View {
    var body: some View {
        Form {
            Section("Inspector section") {
                Text("Inspector content")
                LabeledContent("Property", value: "Value")
            }
        }
        .inspectorColumnWidth(min: 200, ideal: 260)
    }
}

private struct InlineTitleDetailView: View {
    var body: some View {
        List {
            Text("Detail with an inline navigation title and a bottom bar.")
        }
        .navigationTitle("Inline title")
        #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Bottom bar") {}
                    Spacer()
                    Text("Bottom bar text")
                }
            }
        #endif
    }
}

#Preview {
    PresentationsShowcaseView()
}
