//
//  ReceiptExtraction.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Foundation
import FoundationModels

@Generable
struct FoundationReceipt {

    @Guide(description: "The name of the store or merchant.")
    let merchant: String

    @Guide(description: "The date printed on the receipt, if present.")
    let date: String?

    @Guide(description: "All purchased items found on the receipt.")
    let items: [FoundationReceiptItem]

    @Guide(description: "Subtotal amount, if explicitly present.")
    let subtotal: Double?

    @Guide(description: "Tax or GST amount, if explicitly present.")
    let tax: Double?

    @Guide(description: "Final amount paid by the customer.")
    let total: Double
}
