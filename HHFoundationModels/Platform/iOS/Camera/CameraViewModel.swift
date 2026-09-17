//
//  CameraViewModel.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

#if os(iOS)
import Combine
import UIKit

@MainActor
final class CameraViewModel: ObservableObject {

    @Published private(set) var isCameraAuthorized = false
    @Published private(set) var isCameraReady = false
    
    @Published private(set) var receipt: Receipt?
    @Published private(set) var recognizedText: [String] = []
    
    @Published private(set) var isProcessing = false
    @Published var errorMessage: String?

    let cameraService: CameraServiceProtocol

    private let visionService: VisionServiceProtocol
    private let foundationService: FoundationModelServiceProtocol

    init(
        cameraService: CameraServiceProtocol,
        visionService: VisionServiceProtocol,
        foundationService: FoundationModelServiceProtocol
    ) {
        self.cameraService = cameraService
        self.visionService = visionService
        self.foundationService = foundationService
    }

    func prepareCamera() async {

        let authorized = await cameraService.requestPermission()

        guard authorized else {
            isCameraAuthorized = false
            errorMessage = CameraError.permissionDenied.localizedDescription
            return
        }

        isCameraAuthorized = true

        do {
            try cameraService.configure()
            cameraService.start()

            isCameraReady = true

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func stopCamera() {
        cameraService.stop()
    }
    
    func captureAndProcessReceipt() async {
        
        guard !isProcessing, isCameraReady else {
            return
        }
        
        isProcessing = true
        errorMessage = nil
        defer {
            isProcessing = false
        }
        
        do {
            // 1. Capture
            let image = try await cameraService.capturePhoto()
            
            guard let cgImage = image.cgImage else {
                throw VisionError.invalidImage
            }
            
            // 2. OCR
            let lines = try await visionService.recognizeText(
                from: cgImage
            )
            recognizedText = lines
            
            guard !lines.isEmpty else {
                throw VisionError.noTextFound
            }
            
            // 3. Convert OCR lines to text
            let ocrText = lines.joined(
                separator: "\n"
            )
            
            // 4. Foundation Models
            let extraction = try await foundationService.parseReceipt(from: ocrText)
            
            // 5. Convert AI model to domain model
            receipt = extraction.toReceipt()
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
}
#endif
