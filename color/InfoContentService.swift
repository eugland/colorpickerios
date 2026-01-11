//
//  InfoContentService.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

struct InfoDetailSection: Identifiable {
    let id = UUID()
    let heading: String
    let paragraphs: [String]
    let bullets: [String]

    init(heading: String, paragraphs: [String], bullets: [String] = []) {
        self.heading = heading
        self.paragraphs = paragraphs
        self.bullets = bullets
    }
}

struct InfoContent {
    let title: String
    let sections: [InfoDetailSection]
}

enum InfoContentKind: String, CaseIterable, Identifiable {
    case privacyStatement
    case usageGuide
    case copyrightNotice

    var id: String { rawValue }

    var title: String {
        switch self {
        case .privacyStatement:
            return "Privacy Statement"
        case .usageGuide:
            return "Usage Guide"
        case .copyrightNotice:
            return "Copyright Notice"
        }
    }

    var subtitle: String {
        switch self {
        case .privacyStatement:
            return "How we handle data in the color picker."
        case .usageGuide:
            return "Tips for capturing and organizing colors."
        case .copyrightNotice:
            return "Intellectual property and ownership details."
        }
    }
}

enum InfoContentService {
    static func content(for kind: InfoContentKind) -> InfoContent {
        switch kind {
        case .privacyStatement:
            return InfoContent(
                title: kind.title,
                sections: [
                    InfoDetailSection(
                        heading: "Data collection",
                        paragraphs: [
                            "The Color app does not collect personal information.",
                            "We do not require sign-in or account creation to use core features."
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Local storage",
                        paragraphs: [
                            "Saved palettes and preferences stay on your device.",
                            "If you delete the app, local data is removed as well."
                        ],
                        bullets: [
                            "Palette names and swatches",
                            "Theme and accessibility preferences"
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Contact",
                        paragraphs: [
                            "If you have questions about privacy, please contact support through the feedback form in Explore."
                        ]
                    )
                ]
            )
        case .usageGuide:
            return InfoContent(
                title: kind.title,
                sections: [
                    InfoDetailSection(
                        heading: "Pick a color",
                        paragraphs: [
                            "Use the picker to capture a color from any area on screen.",
                            "Adjust the crosshair size and shape in Explore for precision."
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Save and organize",
                        paragraphs: [
                            "Add colors to your palette for quick reference.",
                            "Rename palettes to keep projects organized."
                        ],
                        bullets: [
                            "Tap a color to copy its hex value",
                            "Use palettes to group branding colors"
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Share",
                        paragraphs: [
                            "Export palette information when collaborating with teammates."
                        ]
                    )
                ]
            )
        case .copyrightNotice:
            return InfoContent(
                title: kind.title,
                sections: [
                    InfoDetailSection(
                        heading: "Ownership",
                        paragraphs: [
                            "Color and its branding assets are owned by Primortex.",
                            "All rights are reserved unless explicitly stated otherwise."
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Permissions",
                        paragraphs: [
                            "You may not copy, modify, distribute, or sell any part of the app without prior written permission."
                        ]
                    ),
                    InfoDetailSection(
                        heading: "Open source",
                        paragraphs: [
                            "Third-party libraries retain their respective licenses."
                        ]
                    )
                ]
            )
        }
    }
}
