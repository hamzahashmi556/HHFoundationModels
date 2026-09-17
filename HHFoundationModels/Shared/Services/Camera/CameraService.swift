//
//  CameraService.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

#if os(iOS)
import AVFoundation
import UIKit

final class CameraService: NSObject, CameraServiceProtocol {

    let session = AVCaptureSession()

    private let photoOutput = AVCapturePhotoOutput()
    
    private var captureContinuation:
            CheckedContinuation<UIImage, Error>?

    func requestPermission() async -> Bool {

        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            return true

        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)

        case .denied, .restricted:
            return false

        @unknown default:
            return false
        }
    }

    func configure() throws {

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else {
            throw CameraError.unavailable
        }

        let input = try AVCaptureDeviceInput(device: camera)
        session.beginConfiguration()

        defer {
            session.commitConfiguration()
        }

        session.sessionPreset = .photo

        guard session.canAddInput(input) else {
            throw CameraError.configurationFailed
        }

        guard session.canAddOutput(photoOutput) else {
            throw CameraError.configurationFailed
        }
        photoOutput.isHighResolutionCaptureEnabled = true
        session.addInput(input)
        session.addOutput(photoOutput)
    }

    func start() {
        guard !session.isRunning else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        guard session.isRunning else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    func capturePhoto() async throws -> UIImage {
        
        guard session.isRunning else {
            throw CameraError.captureFailed
        }
        
        guard captureContinuation == nil else {
            throw CameraError.captureInProgress
        }
        
        let settings = AVCapturePhotoSettings()
        
        settings.flashMode = .off
        
        settings.isHighResolutionPhotoEnabled = true
        
        return try await withCheckedThrowingContinuation {
            continuation in
            
            captureContinuation = continuation
            
            photoOutput.capturePhoto(
                with: settings,
                delegate: self
            )
        }
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {

        if let error {

            captureContinuation?.resume(
                throwing: error
            )

            captureContinuation = nil

            return
        }

        guard let data = photo.fileDataRepresentation() else {

            captureContinuation?.resume(
                throwing: CameraError.captureFailed
            )

            captureContinuation = nil

            return
        }

        guard let image = UIImage(data: data) else {

            captureContinuation?.resume(
                throwing: CameraError.captureFailed
            )

            captureContinuation = nil

            return
        }

        captureContinuation?.resume(
            returning: image
        )

        captureContinuation = nil
    }
}

#endif
