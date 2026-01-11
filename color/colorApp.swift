//
//  colorApp.swift
//  color
//
//  Created by eugland on 2026-01-10.
//

import SwiftUI

@main
struct colorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let services = AppServices.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services.settingsStore)
                .environmentObject(services.paletteStore)
                .environmentObject(services.recentPicksStore)
                .environment(\.locale, Locale(identifier: services.settingsStore.languageTag))
                .preferredColorScheme(services.settingsStore.preferredColorScheme)
        }
    }
}
