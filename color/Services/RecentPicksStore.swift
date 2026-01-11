//
//  RecentPicksStore.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation
import SwiftUI

@MainActor
final class RecentPicksStore: ObservableObject {
    @Published private(set) var history: [PickedColor] = []
    @Published private(set) var saved: [PickedColor] = []

    private let historyLimit: Int
    private let storageURL: URL

    init(historyLimit: Int = 100, storageFilename: String = "recent-picks.json") {
        self.historyLimit = historyLimit
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        self.storageURL = (dir ?? FileManager.default.temporaryDirectory).appendingPathComponent(storageFilename)
        load()
    }

    func addPick(_ pick: PickedColor) {
        history.insert(pick, at: 0)
        if history.count > historyLimit {
            history = Array(history.prefix(historyLimit))
        }
        save()
    }

    func toggleSaved(_ pick: PickedColor) {
        if let index = saved.firstIndex(of: pick) {
            saved.remove(at: index)
        } else {
            saved.insert(pick, at: 0)
        }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: storageURL) else { return }
        let decoded = try? JSONDecoder().decode(StorePayload.self, from: data)
        history = decoded?.history ?? []
        saved = decoded?.saved ?? []
    }

    private func save() {
        let payload = StorePayload(history: history, saved: saved)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        try? FileManager.default.createDirectory(at: storageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: storageURL, options: .atomic)
    }

    private struct StorePayload: Codable {
        let history: [PickedColor]
        let saved: [PickedColor]
    }
}
