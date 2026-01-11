//
//  ColorSliderView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ColorSliderView: View {
    @State private var mode: String = "RGB"

    var body: some View {
        Form {
            Picker("Mode", selection: $mode) {
                Text("RGB").tag("RGB")
                Text("HSL").tag("HSL")
                Text("HSV").tag("HSV")
                Text("CMYK").tag("CMYK")
            }
            .pickerStyle(.segmented)

            Text(String(format: String(localized: "Sliders for %@ values will appear here."), mode))
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Color Slider")
    }
}

#Preview {
    NavigationStack {
        ColorSliderView()
    }
}
