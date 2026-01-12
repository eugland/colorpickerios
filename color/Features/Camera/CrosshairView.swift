//
//  CrosshairView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI

struct CrosshairView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let lineLength = size * 0.08

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.85), lineWidth: 2)
                    .frame(width: lineLength * 2.2, height: lineLength * 2.2)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)

                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: lineLength, height: 2)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 2, height: lineLength)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .allowsHitTesting(false)
    }
}
