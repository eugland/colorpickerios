//
//  ContentView.swift
//  color
//
//  Created by eugland on 2026-01-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PaletteListView()
                .tabItem {
                    Label("Palettes", systemImage: "square.grid.2x2")
                }

            CameraTabView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PaletteStore())
        .environmentObject(SettingsStore())
}
