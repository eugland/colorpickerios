//
//  InfoDetailView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct InfoDetailView: View {
    let page: String
    @EnvironmentObject private var settingsStore: SettingsStore
    @State private var content: InfoContentService.InfoContent?
    @State private var loadError: String?
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let content {
                    ForEach(Array(content.sections.enumerated()), id: \.offset) { _, section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.heading)
                                .font(.title3)
                                .fontWeight(.semibold)
                            ForEach(section.paragraphs, id: \.self) { paragraph in
                                Text(paragraph)
                                    .foregroundStyle(.secondary)
                            }
                            if !section.bullets.isEmpty {
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(section.bullets, id: \.self) { bullet in
                                        Text("• \(bullet)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    if content.sections.isEmpty {
                        Text("No content available for this page yet.")
                            .foregroundStyle(.secondary)
                    }
                } else if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let loadError {
                    Text(loadError)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(content?.title ?? pageTitle)
        .task(id: "\(page)-\(settingsStore.languageTag)") {
            await loadContent()
        }
    }

    private var pageTitle: String {
        switch page {
        case "privacy":
            return "Privacy Statement"
        case "usage":
            return "Usage Guide"
        case "copyright":
            return "Copyright Notice"
        default:
            return "Info"
        }
    }

    private func loadContent() async {
        isLoading = true
        loadError = nil
        do {
            content = try await AppServices.shared.infoContentService.loadPage(
                page,
                languageTag: settingsStore.languageTag
            )
        } catch {
            loadError = "Unable to load this page right now. Please try again later."
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        InfoDetailView(page: "privacy")
            .environmentObject(SettingsStore())
    }
}
