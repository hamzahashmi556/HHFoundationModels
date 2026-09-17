//
//  PlatformImage.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 17/09/2026.
//


// PlatformImage.swift


#if os(iOS)

import UIKit

extension UIImage {

    var cgImageForVision: CGImage? {
        cgImage
    }
}

#endif


#if os(macOS)

import AppKit

extension NSImage {

    var cgImageForVision: CGImage? {

        var proposedRect = NSRect(
            origin: .zero,
            size: size
        )

        return cgImage(
            forProposedRect: &proposedRect,
            context: nil,
            hints: nil
        )
    }
}

#endif
