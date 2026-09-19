//
//  FilePickerView.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 17/09/2026.
//


#if os(macOS)

import SwiftUI
import AppKit
import UniformTypeIdentifiers

import Combine

class FilePickerViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    @Published private(set) var selectedImage: NSImage?
    @Published private(set) var receipt: Receipt?
    @Published private(set) var alertMessage = ""
    @Published var alertPresented = false
    
    private let visionService: VisionServiceProtocol
    private let foundationService: FoundationModelServiceProtocol
    
    init(visionService: VisionServiceProtocol, foundationService: FoundationModelServiceProtocol) {
        self.visionService = visionService
        self.foundationService = foundationService
    }

    func parseReceipt(from image: NSImage) {
        self.isLoading = true
        Task { @MainActor in
            var proposedRect = NSRect(
                origin: .zero,
                size: image.size
            )
            guard let cgImage = image.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil) else {
                print("No CGImage found")
                return
            }
            do {
                let detectedLines = try await visionService.recognizeText(from: cgImage)
                guard !detectedLines.isEmpty else { throw VisionError.noTextFound }
                
                // 3. Convert OCR lines to text
                let ocr = detectedLines.joined(separator: "\n")
                
                let foundationReceipt = try await foundationService.parseReceipt(from: ocr)
                let receipt = foundationReceipt.toReceipt()
                self.selectedImage = image
                self.receipt = receipt
                
            }
            catch {
                print("Receipt Analyze Failed: \(error)")
                self.alertMessage = error.localizedDescription
                self.alertPresented = true
            }
            self.isLoading = false
        }
    }
}

struct FilePickerView: View {
        
    @StateObject var vm: FilePickerViewModel

    var body: some View {
        
        NavigationStack {
            if let selectedImage = vm.selectedImage {
                HStack {
                    Image(nsImage: selectedImage)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                    
                    if let receipt = vm.receipt {
                        ReceiptView(receipt: receipt)
                    }
                    else {
                        Text("No Items Detected from Receipt")
                    }
                }
            }
            else {
                Text("No Image Selected")
            }
        }
        .overlay {
            if vm.isLoading { ProgressView() }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Button("Select File") {
                    let openPanel = NSOpenPanel()
                    openPanel.canChooseFiles = true
                    openPanel.allowedContentTypes = [.png, .jpeg, .webP, .image]//["png", "jpg", "jpeg"]
                    
                    if openPanel.runModal() == .OK, let url = openPanel.url {
                        if let nsImage = NSImage(contentsOf: url) {
                            vm.parseReceipt(from: nsImage)
                        }
                    }
                }
            }
        })
        .alert(vm.alertMessage, isPresented: $vm.alertPresented) {
            
        }
    }
}

#endif

//#Preview {
//    FilePickerView(
//        vm: FilePickerViewModel(
//            visionService: VisionService(),
//            foundationService: FoundationModelService()
//        )
//    )
//    .frame(width: .infinity, height: .infinity)
////    Text("Hello World")
//}
