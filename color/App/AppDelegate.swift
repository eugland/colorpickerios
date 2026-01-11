//
//  AppDelegate.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        _ = AppServices.shared
        return true
    }
}
