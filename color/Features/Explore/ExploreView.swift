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
                NavigationLink("Info") {
                    InfoDetailView(page: "privacy")
                }
                NavigationLink("Language") {
                    LanguageSelectionView()
                }
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
