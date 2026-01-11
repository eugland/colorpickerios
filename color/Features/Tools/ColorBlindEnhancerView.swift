//
//  ColorBlindEnhancerView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ColorBlindEnhancerView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Color Blind Enhancer")
                .font(.title2)
            Text("Tooling UI will appear here.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Enhancer")
    }
}

#Preview {
    ColorBlindEnhancerView()
}
