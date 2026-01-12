//
//  ExploreScreen.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ExploreScreen: View {
    private let infoItems = InfoContentKind.allCases

    var body: some View {
        NavigationStack {
            List {
                Section("Information") {
                    ForEach(infoItems) { item in
                        NavigationLink {
                            InfoDetailView(content: InfoContentService.content(for: item))
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreScreen()
}
