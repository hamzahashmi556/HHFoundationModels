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

struct FilePickerView: View {
    
    @State private var selectedImage: Image?
    @State private var receipt: Receipt?
    
    let visionService: VisionServiceProtocol
    let foundationService: FoundationModelServiceProtocol

    var body: some View {
        Button("Select File") {
            let openPanel = NSOpenPanel()
            openPanel.canChooseFiles = true
            openPanel.allowedContentTypes = [.png, .jpeg, .webP, .image]//["png", "jpg", "jpeg"]
            
            if openPanel.runModal() == .OK, let url = openPanel.url {
                if let nsImage = NSImage(contentsOf: url) {
                    selectedImage = Image(nsImage: nsImage)
                }
            }
        }
        .sheet(item: $receipt) { receipt in
            ReceiptView(receipt: receipt)
        }
    }
    
    func parseReceipt(from image: NSImage) {
        Task {
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
                self.receipt = receipt
                
            }
            catch {
                print("Receipt Analyze Failed: \(error)")
            }
        }
    }
}

#endif
