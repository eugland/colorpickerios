//
//  LiveCameraView.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import SwiftUI
import UIKit

struct LiveCameraView: View {
    @EnvironmentObject private var recentPicksStore: RecentPicksStore
    @StateObject private var viewModel = LiveCameraViewModel()
    @State private var showDetails = false
    @State private var showSavedConfirmation = false

    var body: some View {
        ZStack {
            if viewModel.permissionState == .authorized {
                cameraContent
            } else {
                permissionContent
            }
        }
        .navigationTitle("Live Camera")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.prepare()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .navigationDestination(isPresented: $showDetails) {
            ColorDetailsView(argb: viewModel.sampledColor.argb, nameHint: viewModel.sampledColor.name)
        }
    }

    private var cameraContent: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .ignoresSafeArea()

            CrosshairView()

            VStack(spacing: 12) {
                Spacer()
                liveColorCard
                addToSavedButton
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    private var liveColorCard: some View {
        Button {
            showDetails = true
        } label: {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.fromARGB(viewModel.sampledColor.argb))
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(Color.black.opacity(0.12), lineWidth: 1))

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.sampledColor.name ?? "Live Pick")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(viewModel.sampledColor.hex)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospaced()
                    Text("Tap to view details")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private var addToSavedButton: some View {
        Button {
            addCurrentPick()
        } label: {
            Label(showSavedConfirmation ? "Added" : "Add to Saved", systemImage: "plus.circle.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(showSavedConfirmation ? .green : .accentColor)
    }

    private var permissionContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            Text("Camera Access Needed")
                .font(.title3.bold())
            Text(viewModel.permissionDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if viewModel.permissionState == .denied || viewModel.permissionState == .restricted {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    private func addCurrentPick() {
        let name = viewModel.sampledColor.name ?? viewModel.sampledColor.hex
        let pick = PickedColor(argb: viewModel.sampledColor.argb, name: name)
        recentPicksStore.addPick(pick)
        recentPicksStore.toggleSaved(pick)

        withAnimation(.easeInOut(duration: 0.2)) {
            showSavedConfirmation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showSavedConfirmation = false
            }
        }
    }
}

#Preview {
    LiveCameraView()
        .environmentObject(RecentPicksStore())
}
