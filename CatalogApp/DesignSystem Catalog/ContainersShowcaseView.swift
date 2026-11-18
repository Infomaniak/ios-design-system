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

struct ContainersShowcaseView: View {
    var body: some View {
        NavigationStack {
            List {
                HeaderFooterSection()
                LabelSection()
                GroupingSection()
                ProgressSection()
                RowActionSection()
                Section("Navigation") {
                    NavigationLink("ContentUnavailableView") {
                        ContentUnavailableShowcaseView()
                    }
                    NavigationLink("Searchable list") {
                        SearchShowcaseView()
                    }
                    NavigationLink("Plain list") {
                        PlainListShowcaseView()
                    }
                }
            }
            .navigationTitle("Containers")
            .navigationSubtitle("Lists, forms and grouping")
        }
    }
}

private struct HeaderFooterSection: View {
    var body: some View {
        Section {
            Text("Row content")
        } header: {
            Text("Section header")
        } footer: {
            Text("Section footer: Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
    }
}

private struct LabelSection: View {
    var body: some View {
        Section("Labels") {
            LabeledContent("LabeledContent", value: "Value")
            LabeledContent("LabeledContent format", value: 1234.5, format: .currency(code: "CHF"))
            LabeledContent {
                Text("Custom content")
            } label: {
                Text("LabeledContent")
                Text("Label subtitle")
            }
            Label("Label", systemImage: "star")
            Label("Label .titleOnly", systemImage: "star")
                .labelStyle(.titleOnly)
        }
    }
}

private struct GroupingSection: View {
    @State private var isExpanded = true

    var body: some View {
        Section("Grouping") {
            DisclosureGroup("DisclosureGroup", isExpanded: $isExpanded) {
                Text("Disclosed content")
            }
            GroupBox("GroupBox") {
                Text("Group box content")
            }
            GroupBox {
                Text("Group box with Label")
            } label: {
                Label("GroupBox label", systemImage: "shippingbox")
            }
        }
    }
}

private struct ProgressSection: View {
    var body: some View {
        Section("Progress") {
            ProgressView("ProgressView indeterminate")
            ProgressView(value: 0.4) {
                Text("ProgressView with label")
            } currentValueLabel: {
                Text("40 % complete")
            }
            Gauge(value: 0.6) {
                Text("Gauge")
            } currentValueLabel: {
                Text("60 %")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
            ShowcaseRow(".gaugeStyle(.accessoryCircular)") {
                Gauge(value: 0.6) {
                    Text("Gauge")
                } currentValueLabel: {
                    Text("60")
                }
                .gaugeStyle(.accessoryCircular)
            }
        }
    }
}

private struct RowActionSection: View {
    private static let rows = ["Inbox", "Drafts", "Archive"]

    var body: some View {
        Section("Rows: badge & swipe actions") {
            ForEach(Self.rows, id: \.self) { row in
                Text(row)
                    .badge(row.count)
                    .swipeActions(edge: .leading) {
                        Button("Pin", systemImage: "pin") {}
                            .tint(.orange)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {}
                        Button("Flag") {}
                            .tint(.blue)
                    }
            }
            Text("Text badge")
                .badge("New")
        }
    }
}

private struct ContentUnavailableShowcaseView: View {
    var body: some View {
        VStack {
            ContentUnavailableView {
                Label("No mail", systemImage: "tray")
            } description: {
                Text("ContentUnavailableView description")
            } actions: {
                Button("Refresh") {}
                    .buttonStyle(.borderedProminent)
            }
            ContentUnavailableView.search(text: "Lorem")
        }
        .navigationTitle("Unavailable")
    }
}

private struct PlainListShowcaseView: View {
    var body: some View {
        List {
            Section("Plain section header") {
                Text("Plain row")
                Text("Plain row")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Plain list")
        #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    ContainersShowcaseView()
}
