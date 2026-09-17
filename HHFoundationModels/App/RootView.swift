//
//  RootView.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 17/09/2026.
//

import SwiftUI

struct RootView: View {
    
//    @EnvironmentObject private var container: AppContainer
    
    private let foundationService: FoundationModelServiceProtocol = FoundationModelService()
    private let visionService: VisionServiceProtocol = VisionService()
    
    var body: some View {
        
        #if os(macOS)
        FilePickerView(
            visionService: visionService,
            foundationService: foundationService
        )
        #elseif os(iOS)
        CameraView(
            viewModel: CameraViewModel(
                cameraService: CameraService.init(),
                visionService: VisionService.init(),
                foundationService: foundationService
            )
        )
        #endif
    }
}
