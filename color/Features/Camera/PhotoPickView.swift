//
//  PhotoPickView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct PhotoPickView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Photo Picker")
                .font(.title2)
            Text("Select a photo and sample pixels from it.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Photo Picker")
    }
}

#Preview {
    PhotoPickView()
}
