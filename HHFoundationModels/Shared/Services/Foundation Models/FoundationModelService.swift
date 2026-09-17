//
//  FoundationModelService.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import FoundationModels

final class FoundationModelService: FoundationModelServiceProtocol {

    private let session: LanguageModelSession
    
    init() {
        self.session = LanguageModelSession(
            instructions: """
                    You are a receipt extraction system.
                    
                    Extract structured information from OCR text produced
                    from a shopping receipt.
                    
                    Rules:
                    - Extract only information supported by the OCR text.
                    - Do not invent missing values.
                    - Preserve item names as accurately as possible.
                    - Identify the final amount paid as the total.
                    - If subtotal or tax cannot be identified, return nil.
                    - Ignore addresses, phone numbers, cashier information,
                      payment metadata, and promotional text.
                    """
        )
    }

    func parseReceipt(
        from text: String
    ) async throws -> FoundationReceipt {
        
        let response = try await session.respond(
            to:
                    """
                    Parse the following OCR text from a receipt:
                    
                    ---
                    \(text)
                    ---
                    """,
            generating: FoundationReceipt.self
        )
        
        return response.content
    }
}
