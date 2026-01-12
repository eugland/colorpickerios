//
//  LiveCameraViewModel.swift
//  color
//
//  Created by OpenAI on 2026-01-10.
//

import AVFoundation
import CoreImage
import SwiftUI

@MainActor
final class LiveCameraViewModel: NSObject, ObservableObject {
    enum PermissionState {
        case unknown
        case authorized
        case denied
        case restricted
    }

    struct SampledColor {
        let argb: Int
        let name: String?
        let hex: String
    }

    @Published private(set) var permissionState: PermissionState = .unknown
    @Published private(set) var sampledColor: SampledColor = SampledColor(argb: 0xFFFFFFFF, name: "White", hex: "#FFFFFFFF")

    let session = AVCaptureSession()

    private let output = AVCaptureVideoDataOutput()
    private let outputQueue = DispatchQueue(label: "live.camera.output")
    private let context = CIContext(options: [.workingColorSpace: CGColorSpaceCreateDeviceRGB()])
    private var isConfigured = false

    func prepare() async {
        await requestPermissionIfNeeded()
        if permissionState == .authorized {
            configureIfNeeded()
            startSession()
        }
    }

    func stopSession() {
        guard session.isRunning else { return }
        session.stopRunning()
    }

    var permissionDescription: String {
        switch permissionState {
        case .denied:
            return "Allow camera access to pick colors from the live feed."
        case .restricted:
            return "Camera access is restricted on this device."
        default:
            return "Enable the camera to start live picking."
        }
    }

    private func requestPermissionIfNeeded() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionState = .authorized
        case .denied:
            permissionState = .denied
        case .restricted:
            permissionState = .restricted
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            permissionState = granted ? .authorized : .denied
        @unknown default:
            permissionState = .denied
        }
    }

    private func configureIfNeeded() {
        guard !isConfigured else { return }
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        if session.canAddOutput(output) {
            output.setSampleBufferDelegate(self, queue: outputQueue)
            session.addOutput(output)
        }

        if let connection = output.connection(with: .video) {
            connection.videoOrientation = .portrait
        }

        session.commitConfiguration()
        isConfigured = true
    }

    private func startSession() {
        guard !session.isRunning else { return }
        outputQueue.async { [weak session] in
            session?.startRunning()
        }
    }
}

extension LiveCameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let extent = ciImage.extent
        let samplePoint = CGPoint(x: extent.midX, y: extent.midY)
        guard let argb = sampleColor(from: ciImage, at: samplePoint) else { return }

        let hex = String(format: "#%08X", argb)
        let name = AppServices.shared.colorNameService.nearestName(argb: argb)
        let sample = SampledColor(argb: argb, name: name, hex: hex)

        Task { @MainActor in
            self.sampledColor = sample
        }
    }

    private func sampleColor(from image: CIImage, at point: CGPoint) -> Int? {
        let width = 1
        let height = 1
        let rect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
        var pixel = [UInt8](repeating: 0, count: width * height * 4)
        context.render(
            image,
            toBitmap: &pixel,
            rowBytes: width * 4,
            bounds: rect,
            format: .BGRA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        let blue = Int(pixel[0])
        let green = Int(pixel[1])
        let red = Int(pixel[2])
        let alpha = Int(pixel[3])
        return (alpha << 24) | (red << 16) | (green << 8) | blue
    }
}
