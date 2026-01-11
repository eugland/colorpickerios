//
//  ColorDetailsView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct ColorDetailsView: View {
    let details: ColorDetails

    var body: some View {
        Form {
            Section("Color") {
                Text(details.name ?? String(localized: "Unknown"))
                Text(details.hex)
                LabeledContent("Luminance") {
                    Text(details.luminance, format: .number.precision(.fractionLength(2)))
                }
            }
        }
        .navigationTitle("Color Details")
    }
}
