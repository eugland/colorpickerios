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
            Text(String(localized: String.LocalizationValue(pick.name)))
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
            Text(String(localized: String.LocalizationValue(palette.name)))
                .font(.headline)
            if !palette.tags.isEmpty {
                let tagText = palette.tags.map { String(localized: String.LocalizationValue($0)) }
                    .joined(separator: " • ")
                Text(tagText)
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
        PickedColor(argb: 0xFFFF6B6B, name: "Coral"),
        PickedColor(argb: 0xFFFFC857, name: "Marigold"),
        PickedColor(argb: 0xFF4ECDC4, name: "Lagoon"),
        PickedColor(argb: 0xFF5567FF, name: "Periwinkle"),
        PickedColor(argb: 0xFFFF6B6B, name: "Coral"),
        PickedColor(argb: 0xFFFFC857, name: "Marigold"),
        PickedColor(argb: 0xFF4ECDC4, name: "Lagoon"),
        PickedColor(argb: 0xFF5567FF, name: "Periwinkle"),
        PickedColor(argb: 0xFFFF6B6B, name: "Coral"),
        PickedColor(argb: 0xFFFFC857, name: "Marigold"),
        PickedColor(argb: 0xFF4ECDC4, name: "Lagoon"),
        PickedColor(argb: 0xFF5567FF, name: "Periwinkle"),
        PickedColor(argb: 0xFFFF6B6B, name: "Coral"),
        PickedColor(argb: 0xFFFFC857, name: "Marigold"),
        PickedColor(argb: 0xFF4ECDC4, name: "Lagoon"),
        PickedColor(argb: 0xFF5567FF, name: "Periwinkle"),
        
    ]

    static let savedColors: [PickedColor] = [
        PickedColor(argb: 0xFF1A535C, name: "Deep Teal"),
        PickedColor(argb: 0xFF9B5DE5, name: "Violet"),
        PickedColor(argb: 0xFF00BBF9, name: "Sky Burst"),
        PickedColor(argb: 0xFF00F5D4, name: "Mint")
    ]

    static let savedPalettes: [Palette] = [
        Palette(
            name: "Summer Market",
            colors: [
                PickedColor(argb: 0xFFFF9F1C, name: "Mango"),
                PickedColor(argb: 0xFFFFBF69, name: "Apricot"),
                PickedColor(argb: 0xFFCBF3F0, name: "Sea Mist"),
                PickedColor(argb: 0xFF2EC4B6, name: "Lagoon"),
                PickedColor(argb: 0xFFEF476F, name: "Watermelon")
            ],
            tags: ["warm", "vibrant"],
            note: "Pop color accents for retail displays"
        ),
        Palette(
            name: "Night Drive",
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: "Midnight"),
                PickedColor(argb: 0xFF7E7F9A, name: "Steel"),
                PickedColor(argb: 0xFFD4D6F6, name: "Fog"),
                PickedColor(argb: 0xFF3D5A80, name: "Indigo"),
                PickedColor(argb: 0xFF98C1D9, name: "Frost")
            ],
            tags: ["cool", "moody"],
            note: "Muted lights for dashboards"
        ),
        Palette(
            name: "Night Drive",
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: "Midnight"),
                PickedColor(argb: 0xFF7E7F9A, name: "Steel"),
                PickedColor(argb: 0xFFD4D6F6, name: "Fog"),
                PickedColor(argb: 0xFF3D5A80, name: "Indigo"),
                PickedColor(argb: 0xFF98C1D9, name: "Frost")
            ],
            tags: ["cool", "moody"],
            note: "Muted lights for dashboards"
        ),
        Palette(
            name: "Night Drive",
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: "Midnight"),
                PickedColor(argb: 0xFF7E7F9A, name: "Steel"),
                PickedColor(argb: 0xFFD4D6F6, name: "Fog"),
                PickedColor(argb: 0xFF3D5A80, name: "Indigo"),
                PickedColor(argb: 0xFF98C1D9, name: "Frost")
            ],
            tags: ["cool", "moody"],
            note: "Muted lights for dashboards"
        ),
        Palette(
            name: "Night Drive",
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: "Midnight"),
                PickedColor(argb: 0xFF7E7F9A, name: "Steel"),
                PickedColor(argb: 0xFFD4D6F6, name: "Fog"),
                PickedColor(argb: 0xFF3D5A80, name: "Indigo"),
                PickedColor(argb: 0xFF98C1D9, name: "Frost")
            ],
            tags: ["cool", "moody"],
            note: "Muted lights for dashboards"
        ),
        Palette(
            name: "Night Drive",
            colors: [
                PickedColor(argb: 0xFF1B1F3B, name: "Midnight"),
                PickedColor(argb: 0xFF7E7F9A, name: "Steel"),
                PickedColor(argb: 0xFFD4D6F6, name: "Fog"),
                PickedColor(argb: 0xFF3D5A80, name: "Indigo"),
                PickedColor(argb: 0xFF98C1D9, name: "Frost")
            ],
            tags: ["cool", "moody"],
            note: "Muted lights for dashboards"
        ),
        Palette(
            name: "Studio Pastels",
            colors: [
                PickedColor(argb: 0xFFFFD6E0, name: "Blush"),
                PickedColor(argb: 0xFFFEE440, name: "Butter"),
                PickedColor(argb: 0xFFB8F2E6, name: "Mint Cream"),
                PickedColor(argb: 0xFFA9DEF9, name: "Baby Blue")
            ],
            tags: ["soft", "editorial"],
            note: "Backgrounds for editorial layouts"
        )
    ]
}

#Preview {
    PaletteListView()
}
