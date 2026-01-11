//
//  PaletteListView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct PaletteListView: View {
    private let recentColors = SampleData.recentColors
    private let savedColors = SampleData.savedColors
    private let savedPalettes = SampleData.savedPalettes

    var body: some View {
        NavigationStack {
            List {
                Section("Recent Colors") {
                    ColorSwatchGrid(picks: recentColors)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }

                Section("Saved Colors") {
                    ColorSwatchGrid(picks: savedColors)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }

                Section("Saved Palettes") {
                    ForEach(savedPalettes) { palette in
                        NavigationLink {
                            PaletteDetailView(palette: palette)
                        } label: {
                            PaletteRow(palette: palette)
                        }
                    }
                }
            }
            .navigationTitle("Palettes")
        }
    }
}

private struct ColorSwatchGrid: View {
    let picks: [PickedColor]

    private let columns = [
        GridItem(.adaptive(minimum: 72), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
            ForEach(picks) { pick in
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.fromARGB(pick.argb))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle().stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                    Text(pick.name)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

private struct PaletteRow: View {
    let palette: Palette

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(palette.name)
                .font(.headline)
            if !palette.tags.isEmpty {
                Text(palette.tags.joined(separator: " • "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                ForEach(palette.colors.prefix(6)) { color in
                    Circle()
                        .fill(Color.fromARGB(color.argb))
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle().stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private enum SampleData {
    static let recentColors: [PickedColor] = [
        PickedColor(argb: 0xFFFF6B6B, name: localized("Coral")),
        PickedColor(argb: 0xFFFFC857, name: localized("Marigold")),
        PickedColor(argb: 0xFF4ECDC4, name: localized("Lagoon")),
        PickedColor(argb: 0xFF5567FF, name: localized("Periwinkle")),
        PickedColor(argb: 0xFFFF6B6B, name: localized("Coral")),
        PickedColor(argb: 0xFFFFC857, name: localized("Marigold")),
        PickedColor(argb: 0xFF4ECDC4, name: localized("Lagoon")),
        PickedColor(argb: 0xFF5567FF, name: localized("Periwinkle")),
        PickedColor(argb: 0xFFFF6B6B, name: localized("Coral")),
        PickedColor(argb: 0xFFFFC857, name: localized("Marigold")),
        PickedColor(argb: 0xFF4ECDC4, name: localized("Lagoon")),
        PickedColor(argb: 0xFF5567FF, name: localized("Periwinkle")),
        PickedColor(argb: 0xFFFF6B6B, name: localized("Coral")),
        PickedColor(argb: 0xFFFFC857, name: localized("Marigold")),
        PickedColor(argb: 0xFF4ECDC4, name: localized("Lagoon")),
        PickedColor(argb: 0xFF5567FF, name: localized("Periwinkle")),
        
    ]

    static let savedColors: [PickedColor] = [
        PickedColor(argb: 0xFF1A535C, name: localized("Deep Teal")),
        PickedColor(argb: 0xFF9B5DE5, name: localized("Violet")),
        PickedColor(argb: 0xFF00BBF9, name: localized("Sky Burst")),
        PickedColor(argb: 0xFF00F5D4, name: localized("Mint"))
    ]

    static let savedPalettes: [Palette] = [
        Palette(
            name: localized("Summer Market"),
            colors: [
                PickedColor(argb: 0xFFFF9F1C, name: localized("Mango")),
                PickedColor(argb: 0xFFFFBF69, name: localized("Apricot")),
                PickedColor(argb: 0xFFCBF3F0, name: localized("Sea Mist")),
                PickedColor(argb: 0xFF2EC4B6, name: localized("Lagoon")),
                PickedColor(argb: 0xFFEF476F, name: localized("Watermelon"))
            ],
            tags: [localized("warm"), localized("vibrant")],
            note: localized("Pop color accents for retail displays")
        ),
        Palette(
            name: localized("Night Drive"),
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: localized("Midnight")),
                PickedColor(argb: 0xFF7E7F9A, name: localized("Steel")),
                PickedColor(argb: 0xFFD4D6F6, name: localized("Fog")),
                PickedColor(argb: 0xFF3D5A80, name: localized("Indigo")),
                PickedColor(argb: 0xFF98C1D9, name: localized("Frost"))
            ],
            tags: [localized("cool"), localized("moody")],
            note: localized("Muted lights for dashboards")
        ),
        Palette(
            name: localized("Night Drive"),
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: localized("Midnight")),
                PickedColor(argb: 0xFF7E7F9A, name: localized("Steel")),
                PickedColor(argb: 0xFFD4D6F6, name: localized("Fog")),
                PickedColor(argb: 0xFF3D5A80, name: localized("Indigo")),
                PickedColor(argb: 0xFF98C1D9, name: localized("Frost"))
            ],
            tags: [localized("cool"), localized("moody")],
            note: localized("Muted lights for dashboards")
        ),
        Palette(
            name: localized("Night Drive"),
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: localized("Midnight")),
                PickedColor(argb: 0xFF7E7F9A, name: localized("Steel")),
                PickedColor(argb: 0xFFD4D6F6, name: localized("Fog")),
                PickedColor(argb: 0xFF3D5A80, name: localized("Indigo")),
                PickedColor(argb: 0xFF98C1D9, name: localized("Frost"))
            ],
            tags: [localized("cool"), localized("moody")],
            note: localized("Muted lights for dashboards")
        ),
        Palette(
            name: localized("Night Drive"),
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: localized("Midnight")),
                PickedColor(argb: 0xFF7E7F9A, name: localized("Steel")),
                PickedColor(argb: 0xFFD4D6F6, name: localized("Fog")),
                PickedColor(argb: 0xFF3D5A80, name: localized("Indigo")),
                PickedColor(argb: 0xFF98C1D9, name: localized("Frost"))
            ],
            tags: [localized("cool"), localized("moody")],
            note: localized("Muted lights for dashboards")
        ),
        Palette(
            name: localized("Night Drive"),
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: localized("Midnight")),
                PickedColor(argb: 0xFF7E7F9A, name: localized("Steel")),
                PickedColor(argb: 0xFFD4D6F6, name: localized("Fog")),
                PickedColor(argb: 0xFF3D5A80, name: localized("Indigo")),
                PickedColor(argb: 0xFF98C1D9, name: localized("Frost"))
            ],
            tags: [localized("cool"), localized("moody")],
            note: localized("Muted lights for dashboards")
        ),
        Palette(
            name: localized("Studio Pastels"),
            colors: [
                PickedColor(argb: 0xFFFFD6E0, name: localized("Blush")),
                PickedColor(argb: 0xFFFEE440, name: localized("Butter")),
                PickedColor(argb: 0xFFB8F2E6, name: localized("Mint Cream")),
                PickedColor(argb: 0xFFA9DEF9, name: localized("Baby Blue"))
            ],
            tags: [localized("soft"), localized("editorial")],
            note: localized("Backgrounds for editorial layouts")
        )
    ]
}

private func localized(_ key: String) -> String {
    String(localized: String.LocalizationValue(key))
}

private func hexString(_ argb: Int) -> String {
    String(format: "#%08X", argb)
}

private extension Color {
    static func fromARGB(_ argb: Int) -> Color {
        let alpha = Double((argb >> 24) & 0xFF) / 255.0
        let red = Double((argb >> 16) & 0xFF) / 255.0
        let green = Double((argb >> 8) & 0xFF) / 255.0
        let blue = Double(argb & 0xFF) / 255.0
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

#Preview {
    PaletteListView()
}
