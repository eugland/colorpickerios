//
//  CameraTabView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct CameraTabView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Live Camera Picker") {
                    LiveCameraView()
                }
                NavigationLink("Photo Picker") {
                    PhotoPickView()
                }
                NavigationLink("Color Slider") {
                    ColorSliderView()
                }
                NavigationLink("Color Blind Enhancer") {
                    ColorBlindEnhancerView()
                }
            }
            .navigationTitle("Camera")
        }
    }
}

#Preview {
    CameraTabView()
}
