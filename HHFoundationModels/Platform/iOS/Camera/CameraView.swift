//
//  CameraView.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

#if os(iOS)
import SwiftUI

struct CameraView: View {

    @StateObject private var viewModel: CameraViewModel

    init(viewModel: @autoclosure @escaping () -> CameraViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {

        ZStack {

            if viewModel.isCameraAuthorized {

                CameraPreview(
                    session: viewModel.cameraService.session
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    captureButton
                        .padding(.bottom, 30)
                }
                
                if viewModel.isProcessing {
                    processingOverlay
                }

            } else {

                permissionView
            }
        }
        .task {
            await viewModel.prepareCamera()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
        .alert(
            "Camera Error",
            isPresented: .constant(viewModel.errorMessage != nil)
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .fullScreenCover(isPresented: .constant(viewModel.receipt != nil)) {
            if let receipt = viewModel.receipt {
                ReceiptView(receipt: receipt)
            }
        }
    }

    private var permissionView: some View {

        VStack(spacing: 16) {

            Image(systemName: "camera.fill")
                .font(.system(size: 50))

            Text("Camera Access Required")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Camera access is required to scan receipts.")

                .multilineTextAlignment(.center)

            Button("Allow Camera Access") {
                // We'll handle Settings flow later.
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

private extension CameraView {

    var captureButton: some View {

        Button {

            Task {
                await viewModel.captureAndProcessReceipt()
            }

        } label: {

            ZStack {

                Circle()
                    .fill(.white)
                    .frame(
                        width: 72,
                        height: 72
                    )

                Circle()
                    .stroke(
                        .black.opacity(0.5),
                        lineWidth: 3
                    )
                    .frame(
                        width: 82,
                        height: 82
                    )
            }
        }
        .disabled(viewModel.isProcessing)
        .opacity(
            viewModel.isProcessing ? 0.5 : 1
        )
    }
}

private extension CameraView {

    var processingOverlay: some View {

        ZStack {

            Color.black
                .opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 16) {

                ProgressView()
                    .scaleEffect(1.4)

                Text("Analyzing receipt...")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
    }
}

#endif
