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
                    Text(color.name)
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
