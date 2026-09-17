//
//  CameraServiceProtocol.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

#if os(iOS)
import AVFoundation
import UIKit

protocol CameraServiceProtocol: AnyObject {

    var session: AVCaptureSession { get }

    func requestPermission() async -> Bool

    func configure() throws

    func start()

    func stop()

    func capturePhoto() async throws -> UIImage
}
#endif
