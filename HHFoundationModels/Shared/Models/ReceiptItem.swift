//
//  ReceiptItem.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//

import Foundation

struct ReceiptItem: Identifiable, Equatable {
    let id: UUID
    let name: String
    let price: Decimal
}
