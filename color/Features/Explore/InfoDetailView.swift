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
            VStack(alignment: .leading, spacing: 16) {
                if let content {
                    Text(content.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(content.body)
                        .foregroundStyle(.secondary)
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
        .navigationTitle(content?.title ?? "Info")
        .task(id: "\(page)-\(settingsStore.languageTag)") {
            await loadContent()
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
