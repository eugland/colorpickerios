//
//  PickedColor.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

struct PickedColor: Codable, Identifiable, Equatable {
    let id: String
    let argb: Int
    let name: String

    init(id: String = UUID().uuidString, argb: Int, name: String) {
        self.id = id
        self.argb = argb
        self.name = name
    }
}
