//
//  ColorDetailsView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI
import UIKit

struct ColorDetailsView: View {
    let argb: Int
    let nameHint: String?

    @State private var details: ColorDetails

    init(argb: Int, nameHint: String? = nil) {
        self.argb = argb
        self.nameHint = nameHint
        _details = State(initialValue: AppServices.shared.colorDetailsService.details(for: argb))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(colorFromARGB(details.argb))
                    .frame(height: 160)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

                headerSection

                actionButtons

                infoChips

                keyValueGrid

                harmonySection

                similarColorsSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .navigationTitle(displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var displayName: String {
        if let name = details.name, !name.isEmpty {
            return name
        }
        return nameHint ?? "Color"
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(colorFromARGB(details.argb))
                .frame(width: 64, height: 64)
                .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(displayName)
                    .font(.title2.bold())
                    .lineLimit(1)
                Text(details.hex)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .monospaced()
            }

            Spacer()

            Button {
                UIPasteboard.general.string = details.hex
            } label: {
                Image(systemName: "doc.on.doc")
            }
            .buttonStyle(.bordered)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                UIPasteboard.general.string = details.hex
            } label: {
                Label("Copy Hex", systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)

            Button {
                UIPasteboard.general.string = displayName
            } label: {
                Label("Copy Name", systemImage: "textformat")
            }
            .buttonStyle(.bordered)
        }
    }

    private var infoChips: some View {
        HStack(spacing: 8) {
            ChipView(text: "Luma \(Int(details.luminance * 100))%")
            ChipView(text: details.isDark ? "Dark" : "Light")
            ChipView(text: "Text: \(details.recommendedOnColor == 0xFFFFFFFF ? "White" : "Black")")
        }
    }

    private var keyValueGrid: some View {
        VStack(spacing: 10) {
            KeyValueRow(key: "RGB", value: "\(details.rgb.r), \(details.rgb.g), \(details.rgb.b)")
            KeyValueRow(
                key: "HSV",
                value: "\(Int(details.hsv.h))°, \(Int(details.hsv.s * 100))%, \(Int(details.hsv.v * 100))%"
            )
            KeyValueRow(
                key: "HSL",
                value: "\(Int(details.hsl.h))°, \(Int(details.hsl.s * 100))%, \(Int(details.hsl.l * 100))%"
            )
        }
    }

    private var harmonySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Harmonies")
                .font(.headline)

            HarmonyRow(label: "Complement", argbs: details.complements)
            HarmonyRow(label: "Triad", argbs: details.triads)
            HarmonyRow(label: "Analogous", argbs: details.analogous)
        }
    }

    private var similarColorsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Similar Colors")
                .font(.headline)

            let columns = [GridItem(.adaptive(minimum: 90), spacing: 12)]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(details.similarColors) { color in
                    NavigationLink {
                        ColorDetailsView(argb: color.argb, nameHint: color.name)
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(colorFromARGB(color.argb))
                                .frame(width: 44, height: 44)
                                .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 1))
                            Text(color.name)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Text(String(format: "#%08X", color.argb))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .monospaced()
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
}

private struct ChipView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .clipShape(Capsule())
    }
}

private struct HarmonyRow: View {
    let label: String
    let argbs: [Int]

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 88, alignment: .leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(argbs, id: \.self) { argb in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(colorFromARGB(argb))
                                .frame(width: 28, height: 28)
                                .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 1))
                            Text(String(format: "#%08X", argb))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .monospaced()
                        }
                    }
                }
            }
        }
    }
}

private struct KeyValueRow: View {
    let key: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(key)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .leading)
            Text(value)
                .font(.callout)
                .monospaced()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private func colorFromARGB(_ argb: Int) -> Color {
    let alpha = Double((argb >> 24) & 0xFF) / 255.0
    let red = Double((argb >> 16) & 0xFF) / 255.0
    let green = Double((argb >> 8) & 0xFF) / 255.0
    let blue = Double(argb & 0xFF) / 255.0
    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
}
