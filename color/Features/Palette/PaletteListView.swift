//
//  PaletteListView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct PaletteListView: View {
    @EnvironmentObject private var paletteStore: PaletteStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(paletteStore.palettes) { palette in
                    NavigationLink(palette.name) {
                        PaletteDetailView(palette: palette)
                    }
                }
            }
            .navigationTitle("Palettes")
            .toolbar {
                Button("Add") {
                    paletteStore.createPalette(named: "New Palette")
                }
            }
        }
    }
}

#Preview {
    PaletteListView()
        .environmentObject(PaletteStore())
}
