//
//  ThemeSelectionView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject private var settingsStore: SettingsStore

    var body: some View {
        Form {
            Picker("Theme", selection: $settingsStore.themeMode) {
                Text("System").tag("system")
                Text("Light").tag("light")
                Text("Dark").tag("dark")
            }
        }
        .navigationTitle("Theme")
    }
}

#Preview {
    NavigationStack {
        ThemeSelectionView()
            .environmentObject(SettingsStore())
    }
}
