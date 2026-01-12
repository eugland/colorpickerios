//
//  Color+ARGB.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

extension Color {
    static func fromARGB(_ argb: Int) -> Color {
        let alpha = Double((argb >> 24) & 0xFF) / 255.0
        let red = Double((argb >> 16) & 0xFF) / 255.0
        let green = Double((argb >> 8) & 0xFF) / 255.0
        let blue = Double(argb & 0xFF) / 255.0
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
