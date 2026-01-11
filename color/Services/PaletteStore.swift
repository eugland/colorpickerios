//
//  PaletteStore.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation
import SwiftUI

@MainActor
final class PaletteStore: ObservableObject {
    @Published private(set) var palettes: [Palette] = []
    private let storageURL: URL

    init(storageFilename: String = "palettes.json") {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        self.storageURL = (dir ?? FileManager.default.temporaryDirectory).appendingPathComponent(storageFilename)
        load()
    }

    func createPalette(named name: String) {
        let palette = Palette(name: name)
        palettes.append(palette)
        save()
    }

    func updatePalette(_ palette: Palette) {
        guard let index = palettes.firstIndex(where: { $0.id == palette.id }) else { return }
        palettes[index] = palette
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: storageURL) else { return }
        if let decoded = try? JSONDecoder().decode([Palette].self, from: data) {
            palettes = decoded
        }
    }

    private func save() {
        let dir = storageURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(palettes) else { return }
        try? data.write(to: storageURL, options: .atomic)
    }
}
