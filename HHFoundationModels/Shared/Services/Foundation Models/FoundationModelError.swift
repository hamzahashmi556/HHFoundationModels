//
//  FoundationModelError.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Foundation

enum FoundationModelError: LocalizedError {

    case unavailable
    case emptyOCRText
    case generationFailed
    case invalidResult

    var errorDescription: String? {

        switch self {

        case .unavailable:
            return "The on-device language model is unavailable."

        case .emptyOCRText:
            return "No OCR text was provided."

        case .generationFailed:
            return "Unable to extract receipt information."

        case .invalidResult:
            return "The extracted receipt data is invalid."
        }
    }
}
