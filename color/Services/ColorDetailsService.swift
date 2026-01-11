//
//  ColorDetailsService.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

struct ColorDetails {
    let argb: Int
    let name: String?
    let hex: String
    let rgb: RGB
    let hsv: HSV
    let hsl: HSL
    let luminance: Double
    let isDark: Bool
    let recommendedOnColor: Int
    let similarColors: [PickedColor]
    let complements: [Int]
    let triads: [Int]
    let analogous: [Int]
}

struct RGB: Equatable {
    let r: Int
    let g: Int
    let b: Int
}

struct HSV: Equatable {
    let h: Double
    let s: Double
    let v: Double
}

struct HSL: Equatable {
    let h: Double
    let s: Double
    let l: Double
}

final class ColorDetailsService {
    private let nameService: ColorNameService

    init(nameService: ColorNameService) {
        self.nameService = nameService
    }

    func details(for argb: Int, similarLimit: Int = 10) -> ColorDetails {
        let hex = String(format: "#%08X", argb)
        let rgb = argbToRgb(argb)
        let hsv = rgbToHsv(rgb)
        let hsl = rgbToHsl(rgb)
        let luminance = relativeLuminance(rgb)
        let isDark = luminance < 0.5
        let recommendedOnColor = isDark ? 0xFFFFFFFF : 0xFF000000
        let complements = [hueShift(argb, byDegrees: 180)]
        let triads = [hueShift(argb, byDegrees: 120), hueShift(argb, byDegrees: 240)]
        let analogous = [hueShift(argb, byDegrees: -30), hueShift(argb, byDegrees: 30)]
        let similarColors = similarColors(to: argb, limit: similarLimit, excludeArgb: argb)
        let name = nameService.nearestName(argb: argb)

        return ColorDetails(
            argb: argb,
            name: name,
            hex: hex,
            rgb: rgb,
            hsv: hsv,
            hsl: hsl,
            luminance: luminance,
            isDark: isDark,
            recommendedOnColor: recommendedOnColor,
            similarColors: similarColors,
            complements: complements,
            triads: triads,
            analogous: analogous
        )
    }

    private func similarColors(to argb: Int, limit: Int, excludeArgb: Int? = nil) -> [PickedColor] {
        let target = argbToRgb(argb)
        return nameService.colors
            .filter { excludeArgb == nil || $0.argb != excludeArgb }
            .sorted { lhs, rhs in
                rgbDistanceSquared(target, argbToRgb(lhs.argb)) < rgbDistanceSquared(target, argbToRgb(rhs.argb))
            }
            .prefix(limit)
            .map { PickedColor(id: String($0.argb), argb: $0.argb, name: $0.name) }
    }
}

private func argbToRgb(_ argb: Int) -> RGB {
    RGB(
        r: (argb >> 16) & 0xFF,
        g: (argb >> 8) & 0xFF,
        b: argb & 0xFF
    )
}

private func rgbToHsv(_ rgb: RGB) -> HSV {
    let r = Double(rgb.r) / 255.0
    let g = Double(rgb.g) / 255.0
    let b = Double(rgb.b) / 255.0

    let maxValue = max(r, g, b)
    let minValue = min(r, g, b)
    let delta = maxValue - minValue

    var hue: Double = 0
    if delta != 0 {
        if maxValue == r {
            hue = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
        } else if maxValue == g {
            hue = ((b - r) / delta) + 2
        } else {
            hue = ((r - g) / delta) + 4
        }
        hue *= 60
        if hue < 0 { hue += 360 }
    }

    let saturation = maxValue == 0 ? 0 : delta / maxValue
    return HSV(h: hue, s: saturation, v: maxValue)
}

private func rgbToHsl(_ rgb: RGB) -> HSL {
    let r = Double(rgb.r) / 255.0
    let g = Double(rgb.g) / 255.0
    let b = Double(rgb.b) / 255.0

    let maxValue = max(r, g, b)
    let minValue = min(r, g, b)
    let delta = maxValue - minValue

    var hue: Double = 0
    if delta != 0 {
        if maxValue == r {
            hue = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
        } else if maxValue == g {
            hue = ((b - r) / delta) + 2
        } else {
            hue = ((r - g) / delta) + 4
        }
        hue *= 60
        if hue < 0 { hue += 360 }
    }

    let lightness = (maxValue + minValue) / 2
    let saturation: Double
    if delta == 0 {
        saturation = 0
    } else {
        saturation = delta / (1 - abs(2 * lightness - 1))
    }
    return HSL(h: hue, s: saturation, l: lightness)
}

private func hslToRgb(_ hsl: HSL) -> RGB {
    let c = (1 - abs(2 * hsl.l - 1)) * hsl.s
    let x = c * (1 - abs((hsl.h / 60).truncatingRemainder(dividingBy: 2) - 1))
    let m = hsl.l - c / 2

    let (rPrime, gPrime, bPrime): (Double, Double, Double)
    switch hsl.h {
    case 0..<60:
        (rPrime, gPrime, bPrime) = (c, x, 0)
    case 60..<120:
        (rPrime, gPrime, bPrime) = (x, c, 0)
    case 120..<180:
        (rPrime, gPrime, bPrime) = (0, c, x)
    case 180..<240:
        (rPrime, gPrime, bPrime) = (0, x, c)
    case 240..<300:
        (rPrime, gPrime, bPrime) = (x, 0, c)
    default:
        (rPrime, gPrime, bPrime) = (c, 0, x)
    }

    return RGB(
        r: Int(round((rPrime + m) * 255)),
        g: Int(round((gPrime + m) * 255)),
        b: Int(round((bPrime + m) * 255))
    )
}

private func hueShift(_ argb: Int, byDegrees shift: Double) -> Int {
    let alpha = (argb >> 24) & 0xFF
    let rgb = argbToRgb(argb)
    var hsl = rgbToHsl(rgb)
    hsl = HSL(h: (hsl.h + shift).truncatingRemainder(dividingBy: 360).nonNegativeHue, s: hsl.s, l: hsl.l)
    let shifted = hslToRgb(hsl)
    return (alpha << 24) | (shifted.r << 16) | (shifted.g << 8) | shifted.b
}

private func relativeLuminance(_ rgb: RGB) -> Double {
    let r = linearize(Double(rgb.r) / 255.0)
    let g = linearize(Double(rgb.g) / 255.0)
    let b = linearize(Double(rgb.b) / 255.0)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
}

private func linearize(_ value: Double) -> Double {
    if value <= 0.03928 {
        return value / 12.92
    }
    return pow((value + 0.055) / 1.055, 2.4)
}

private func rgbDistanceSquared(_ lhs: RGB, _ rhs: RGB) -> Int {
    let dr = lhs.r - rhs.r
    let dg = lhs.g - rhs.g
    let db = lhs.b - rhs.b
    return dr * dr + dg * dg + db * db
}

private extension Double {
    var nonNegativeHue: Double {
        self < 0 ? self + 360 : self
    }
}
