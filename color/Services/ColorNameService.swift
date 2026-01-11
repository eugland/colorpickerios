//
//  ColorNameService.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

final class ColorNameService {
    struct NamedColor: Codable, Equatable {
        let argb: Int
        let name: String
    }

    private(set) var colors: [NamedColor] = []
    private let cacheURL: URL
    private let bundledFilename: String

    init(bundledFilename: String = "colors", cacheFilename: String = "colors-cache.json") {
        self.bundledFilename = bundledFilename
        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        self.cacheURL = (cachesDir ?? FileManager.default.temporaryDirectory).appendingPathComponent(cacheFilename)
        loadBundledColors()
    }

    func loadBundledColors() {
        guard let url = Bundle.main.url(forResource: bundledFilename, withExtension: "json") else {
            colors = []
            return
        }
        colors = loadColors(from: url) ?? []
    }

    func refreshFromRemote(languageTag: String) async throws {
        let url = URL(string: "https://eugland.github.io/color-picker-pages/colors/\(languageTag).json")
        guard let url else { return }
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: cacheURL, options: .atomic)
        let decoded = try JSONDecoder().decode([NamedColor].self, from: data)
        colors = decoded
    }

    func loadCachedColors() {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else { return }
        colors = loadColors(from: cacheURL) ?? colors
    }

    func nearestName(argb: Int) -> String? {
        colors.min { lhs, rhs in
            abs(lhs.argb - argb) < abs(rhs.argb - argb)
        }?.name
    }

    private func loadColors(from url: URL) -> [NamedColor]? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([NamedColor].self, from: data)
    }
}
