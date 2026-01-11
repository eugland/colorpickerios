//
//  LiveCameraView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct LiveCameraView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Live Camera Picker")
                .font(.title2)
            Text("Camera feed and sampling UI will live here.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Live Camera")
    }
}

#Preview {
    LiveCameraView()
}
