//
//  FoundationModelServiceProtocol.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


protocol FoundationModelServiceProtocol {

    func parseReceipt(
        from text: String
    ) async throws -> FoundationReceipt
}
