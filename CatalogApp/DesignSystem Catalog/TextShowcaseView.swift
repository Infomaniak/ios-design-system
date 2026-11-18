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

struct TextShowcaseView: View {
    var body: some View {
        NavigationStack {
            List {
                TextStylingSection()
                TextFormattingSection()
                AppleTextStyleSection()
            }
            .navigationTitle("Text")
        }
    }
}

private struct TextStylingSection: View {
    private static let attributedString: AttributedString = {
        let string = AttributedString("AttributedString with the environment font and ")
        var systemPart = AttributedString("a .body run")
        systemPart.font = .body
        return string + systemPart
    }()

    var body: some View {
        Section("Styling") {
            ShowcaseRow("Text (environment font)") {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            ShowcaseRow("Markdown") {
                Text("**Bold**, *italic*, `code`, ~~strikethrough~~ and [a link](https://www.infomaniak.com)")
            }
            ShowcaseRow("AttributedString") {
                Text(Self.attributedString)
            }
            ShowcaseRow(".bold() / .italic() / .underline()") {
                HStack {
                    Text("Bold").bold()
                    Text("Italic").italic()
                    Text("Underline").underline()
                    Text("All").bold().italic().underline()
                }
            }
            ShowcaseRow(".fontWeight()") {
                HStack {
                    Text("Light").fontWeight(.light)
                    Text("Medium").fontWeight(.medium)
                    Text("Semibold").fontWeight(.semibold)
                    Text("Heavy").fontWeight(.heavy)
                }
            }
            ShowcaseRow("Text concatenation") {
                Text("Environment, ") + Text("medium, ").fontWeight(.medium) + Text("SF .body").font(.body)
            }
        }
    }
}

private struct TextFormattingSection: View {
    var body: some View {
        Section("Formatting") {
            ShowcaseRow(".monospacedDigit()") {
                VStack(alignment: .leading) {
                    Text("1 111 111 · 8 888 888")
                    Text("1 111 111 · 8 888 888").monospacedDigit()
                }
            }
            ShowcaseRow(".monospaced()") {
                Text("let font = Font.body").monospaced()
            }
            ShowcaseRow("Text(date, style: .date / .time / .relative / .timer)") {
                VStack(alignment: .leading) {
                    Text(Date.now, style: .date)
                    Text(Date.now, style: .time)
                    Text(Date.now.addingTimeInterval(-3600), style: .relative)
                    Text(Date.now, style: .timer)
                }
            }
            ShowcaseRow("Text(.now, format:)") {
                VStack(alignment: .leading) {
                    Text(.now, format: .dateTime.weekday(.wide).day().month(.wide).year())
                    Text(1_234_567.89, format: .currency(code: "CHF"))
                    Text(0.42, format: .percent)
                }
            }
            ShowcaseRow(".textCase(.uppercase) / .kerning()") {
                HStack {
                    Text("Uppercase").textCase(.uppercase)
                    Text("Kerning").kerning(3)
                }
            }
        }
    }
}

private struct AppleTextStyleSection: View {
    var body: some View {
        Section {
            ForEach(Font.TextStyle.allCases, id: \.self) { textStyle in
                AppleTextStyleRow(textStyle: textStyle)
            }
        } header: {
            Text("Apple text styles")
        } footer: {
            Text("Apple text styles always use the system font, whatever the environment font.")
        }
    }
}

private struct AppleTextStyleRow: View {
    let textStyle: Font.TextStyle

    var body: some View {
        ShowcaseRow(".\(String(describing: textStyle))") {
            Text("The quick brown fox")
                .font(.system(textStyle))
        }
    }
}

#Preview {
    TextShowcaseView()
}
