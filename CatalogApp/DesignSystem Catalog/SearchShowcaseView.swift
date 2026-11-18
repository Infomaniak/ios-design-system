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

struct SearchShowcaseView: View {
    private static let items = ["Apple", "Apricot", "Banana", "Blueberry", "Cherry", "Grape", "Lemon", "Mango"]

    @State private var query = ""
    @State private var scope = SearchScope.all

    var body: some View {
        List(filteredItems, id: \.self) { item in
            Text(item)
        }
        .navigationTitle("Search")
        #if os(iOS)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Searchable prompt")
        #else
            .searchable(text: $query, prompt: "Searchable prompt")
        #endif
            .searchScopes($scope) {
                ForEach(SearchScope.allCases) { scope in
                    Text(scope.title).tag(scope)
                }
            }
            .searchSuggestions {
                Text("Search suggestion").searchCompletion("Apple")
            }
    }

    private var filteredItems: [String] {
        Self.items.filter { item in
            scope.matches(item) && (query.isEmpty || item.localizedStandardContains(query))
        }
    }
}

private enum SearchScope: String, CaseIterable, Identifiable {
    case all
    case startsWithA
    case others

    var id: Self { self }

    var title: String {
        switch self {
        case .all: "All"
        case .startsWithA: "Starts with A"
        case .others: "Others"
        }
    }

    func matches(_ item: String) -> Bool {
        switch self {
        case .all: true
        case .startsWithA: item.hasPrefix("A")
        case .others: !item.hasPrefix("A")
        }
    }
}

#Preview {
    NavigationStack {
        SearchShowcaseView()
    }
}
