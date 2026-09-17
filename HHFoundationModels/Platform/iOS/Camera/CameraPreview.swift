//
//  CameraPreview.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

#if os(iOS)
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()

        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }

    func updateUIView(
        _ uiView: PreviewView,
        context: Context
    ) {
        uiView.videoPreviewLayer.session = session
    }
}
#endif
