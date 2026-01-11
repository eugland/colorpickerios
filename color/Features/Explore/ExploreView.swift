//
//  ExploreView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Information") {
                    NavigationLink("Privacy Statement") {
                        InfoDetailView(page: "privacy")
                    }
                    NavigationLink("Usage Guide") {
                        InfoDetailView(page: "usage")
                    }
                    NavigationLink("Copyright Notice") {
                        InfoDetailView(page: "copyright")
                    }
                }

                Section("Preferences") {
                    NavigationLink("Language") {
                        LanguageSelectionView()
                    }
                }
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
