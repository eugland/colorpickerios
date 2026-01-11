//
//  AppServices.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

@MainActor
final class AppServices {
    static let shared = AppServices()

    let settingsStore: SettingsStore
    let paletteStore: PaletteStore
    let recentPicksStore: RecentPicksStore
    let colorNameService: ColorNameService
    let colorDetailsService: ColorDetailsService
    let infoContentService: InfoContentService

    private init() {
        let colorNameService = ColorNameService()
        self.settingsStore = SettingsStore()
        self.paletteStore = PaletteStore()
        self.recentPicksStore = RecentPicksStore()
        self.colorNameService = colorNameService
        self.colorDetailsService = ColorDetailsService(nameService: colorNameService)
        self.infoContentService = InfoContentService()
    }
}

