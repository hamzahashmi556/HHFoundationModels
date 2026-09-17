//
//  VisionServiceProtocol.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Vision

protocol VisionServiceProtocol {

    func recognizeText(from cgImage: CGImage) async throws -> [String]
}
