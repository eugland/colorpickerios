//
//  SettingsStore.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    @AppStorage("themeMode") var themeMode: String = "system"
    @AppStorage("crosshairStyle") var crosshairStyle: String = "circle"
    @AppStorage("crosshairSize") var crosshairSize: Double = 24
    @AppStorage("pickerSensitivity") var pickerSensitivity: Double = 1
    @AppStorage("languageTag") var languageTag: String = "en"
}
