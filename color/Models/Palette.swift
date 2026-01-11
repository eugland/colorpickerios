//
//  Palette.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

struct Palette: Codable, Identifiable, Equatable {
    let id: String
    var name: String
    var colors: [PickedColor]
    var tags: [String]
    var note: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        colors: [PickedColor] = [],
        tags: [String] = [],
        note: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colors = colors
        self.tags = tags
        self.note = note
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
