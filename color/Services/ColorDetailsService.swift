//
//  ColorDetailsService.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

struct ColorDetails {
    let argb: Int
    let hex: String
    let luminance: Double
    let name: String?
}

final class ColorDetailsService {
    private let nameService: ColorNameService

    init(nameService: ColorNameService) {
        self.nameService = nameService
    }

    func details(for argb: Int) -> ColorDetails {
        let hex = String(format: "#%08X", argb)
        let luminance = Double((argb >> 16) & 0xFF) * 0.2126
            + Double((argb >> 8) & 0xFF) * 0.7152
            + Double(argb & 0xFF) * 0.0722
        return ColorDetails(argb: argb, hex: hex, luminance: luminance, name: nameService.nearestName(argb: argb))
    }
}
