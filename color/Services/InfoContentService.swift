//
//  InfoContentService.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

final class InfoContentService {
    struct InfoContent: Codable {
        let title: String
        let body: String
    }

    private let cacheDirectory: URL
    private let ttl: TimeInterval

    init(ttl: TimeInterval = 60 * 60 * 24 * 7) {
        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        self.cacheDirectory = cachesDir ?? FileManager.default.temporaryDirectory
        self.ttl = ttl
    }

    func loadPage(_ page: String, languageTag: String) async throws -> InfoContent {
        let cacheURL = cacheDirectory.appendingPathComponent("info-\(page)-\(languageTag).json")
        if let cached = try? loadCached(from: cacheURL), !cached.isExpired(ttl: ttl) {
            #if DEBUG
            print("InfoContentService cache hit for \(cacheURL.lastPathComponent)")
            #endif
            return cached.content
        }
        let url = URL(string: "https://eugland.github.io/color-picker-pages/\(page)/\(languageTag).json")
        guard let url else { throw URLError(.badURL) }
        #if DEBUG
        print("InfoContentService fetching URL: \(url.absoluteString)")
        #endif
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: cacheURL, options: .atomic)
        let decoded = try JSONDecoder().decode(InfoContent.self, from: data)
        #if DEBUG
        let bodyPreview = decoded.body.prefix(160)
        print("InfoContentService response title: \(decoded.title)")
        print("InfoContentService response body preview: \(bodyPreview)")
        #endif
        return decoded
    }

    private func loadCached(from url: URL) throws -> CachedContent? {
        let data = try Data(contentsOf: url)
        let content = try JSONDecoder().decode(InfoContent.self, from: data)
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        let updated = attributes[.modificationDate] as? Date ?? Date.distantPast
        return CachedContent(content: content, updatedAt: updated)
    }

    private struct CachedContent {
        let content: InfoContent
        let updatedAt: Date

        func isExpired(ttl: TimeInterval) -> Bool {
            Date().timeIntervalSince(updatedAt) > ttl
        }
    }
}
