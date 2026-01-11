//
//  PaletteDetailView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct PaletteDetailView: View {
    @EnvironmentObject private var paletteStore: PaletteStore
    @State private var palette: Palette

    init(palette: Palette) {
        _palette = State(initialValue: palette)
    }

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $palette.name)
                TextField("Notes", text: $palette.note, axis: .vertical)
            }

            Section("Colors") {
                ForEach(palette.colors) { color in
                    NavigationLink {
                        ColorDetailsView(argb: color.argb, nameHint: color.name)
                    } label: {
                        PaletteColorRow(color: color)
                    }
                }
            }
        }
        .navigationTitle(palette.name)
        .toolbar {
            Button("Save") {
                palette.updatedAt = Date()
                paletteStore.updatePalette(palette)
            }
        }
    }
}

private struct PaletteColorRow: View {
    let color: PickedColor

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(colorFromARGB(color.argb))
                .frame(width: 32, height: 32)
                .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(color.name)
                    .font(.body)
                Text(String(format: "#%08X", color.argb))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospaced()
            }
        }
        .padding(.vertical, 4)
    }
}

private func colorFromARGB(_ argb: Int) -> Color {
    let alpha = Double((argb >> 24) & 0xFF) / 255.0
    let red = Double((argb >> 16) & 0xFF) / 255.0
    let green = Double((argb >> 8) & 0xFF) / 255.0
    let blue = Double(argb & 0xFF) / 255.0
    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
}
