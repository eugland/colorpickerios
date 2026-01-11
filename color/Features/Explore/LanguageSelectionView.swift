//
//  LanguageSelectionView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject private var settingsStore: SettingsStore

    var body: some View {
        Form {
            Picker("Language", selection: $settingsStore.languageTag) {
                Text("English").tag("en")
                Text("Spanish").tag("es")
                Text("French").tag("fr")
                Text("Japanese").tag("ja")
                Text("Chinese").tag("zh-Hans")
            }
        }
        .navigationTitle("Language")
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
            .environmentObject(SettingsStore())
    }
}
