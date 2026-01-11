//
//  InfoDetailView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct InfoDetailView: View {
    let content: InfoContent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(content.sections) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section.heading)
                            .font(.title3.weight(.semibold))

                        ForEach(section.paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }

                        if !section.bullets.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(section.bullets, id: \.self) { bullet in
                                    Text("• \(bullet)")
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(content.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        InfoDetailView(content: InfoContentService.content(for: .privacyStatement))
    }
}
