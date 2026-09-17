//
//  Receipt.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Foundation

struct Receipt: Identifiable, Equatable {

    let id: UUID
    let merchant: String
    let date: Date?
    let items: [ReceiptItem]
    let subtotal: Decimal?
    let tax: Decimal?
    let total: Decimal
}
