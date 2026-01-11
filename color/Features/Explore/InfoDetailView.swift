//
//  InfoDetailView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct InfoDetailView: View {
    let page: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Info: \(page)")
                .font(.title2)
            Text("Remote content will be loaded here.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Info")
    }
}

#Preview {
    InfoDetailView(page: "privacy")
}
