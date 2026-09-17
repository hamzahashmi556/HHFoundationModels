//
//  VisionService.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

import Vision

final class VisionService: VisionServiceProtocol {
    
    func recognizeText(from cgImage: CGImage) async throws -> [String] {

        let request = VNRecognizeTextRequest()

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )

        try handler.perform([request])

        let lines = request.results?.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        
        return lines ?? []
    }
}
