//
//  CameraError.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

import Foundation

enum CameraError: LocalizedError {

    case permissionDenied
    case unavailable
    case configurationFailed
    case captureFailed
    case captureInProgress

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Camera permission was denied."

        case .unavailable:
            return "Camera is not available."

        case .configurationFailed:
            return "Unable to configure the camera."

        case .captureFailed:
            return "Unable to capture the image."
            
        case .captureInProgress:
            return "A photo is already being captured."
        }
    }
}
