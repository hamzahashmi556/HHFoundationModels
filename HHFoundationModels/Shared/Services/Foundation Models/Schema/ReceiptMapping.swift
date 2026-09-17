//
//  ReceiptMapping.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import Foundation

extension FoundationReceipt {

    public func toReceipt() -> Receipt {

        let items = self.items.map({
            ReceiptItem(id: UUID(), name: $0.name, price: Decimal($0.price))
        })
        return Receipt(
            id: UUID(),
            merchant: merchant,
            date: parseDate(),
            items: items,
            subtotal: subtotal.map({ Decimal($0) }),
            tax: tax.map({ Decimal($0) }),
            total: Decimal(total)
        )
    }

    private func parseDate() -> Date? {

        guard let date else {
            return nil
        }

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.date(from: date)
    }
}
