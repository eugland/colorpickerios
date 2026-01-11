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
    @AppStorage("languageTag") private var languageTag: String = "system"
    @AppStorage("themeMode") private var themeMode: String = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services.settingsStore)
                .environmentObject(services.paletteStore)
                .environmentObject(services.recentPicksStore)
                .environment(\.locale, resolvedLocale)
                .preferredColorScheme(preferredColorScheme)
        }
    }

    private var resolvedLocale: Locale {
        languageTag == "system" ? .current : Locale(identifier: languageTag)
    }

    private var preferredColorScheme: ColorScheme? {
        switch themeMode {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }
}
