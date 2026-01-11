//
//  AnalyticsTracker.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import Foundation

final class AnalyticsTracker {
    static let shared = AnalyticsTracker()

    func track(event: String, parameters: [String: Any] = [:]) {
        // Placeholder for Firebase Analytics.
        print("Analytics event: \(event) \(parameters)")
    }
}
