//
//  VisionError.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

import Foundation

enum VisionError: LocalizedError {

    case invalidImage
    case recognitionFailed
    case noTextFound

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "The image could not be processed."
            
        case .noTextFound:
            return "No text was detected in the image."

        case .recognitionFailed:
            return "Text recognition failed."
        }
    }
}
