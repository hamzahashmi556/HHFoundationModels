//
//  ExtractedReceiptItem.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Foundation
import FoundationModels

@Generable
struct FoundationReceiptItem {

    @Guide(description: "The name or description of the purchased item.")
    let name: String

    @Guide(description: "The price of the item.")
    let price: Double
}
