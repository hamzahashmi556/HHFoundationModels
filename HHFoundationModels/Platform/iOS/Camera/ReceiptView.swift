//
//  ReceiptView.swift
//  HHFoundationModels
//
//  Created by PSG-MDU-HAMZA on 16/09/2026.
//


import SwiftUI

struct ReceiptView: View {

    let receipt: Receipt

    var body: some View {
        NavigationStack {
            List {

                // MARK: - Merchant

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(receipt.merchant)
                            .font(.title2)
                            .fontWeight(.bold)

                        if let date = receipt.date {
                            Text(
                                date.formatted(
                                    date: .abbreviated,
                                    time: .omitted
                                )
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // MARK: - Items

                Section("Items") {

                    ForEach(receipt.items) { item in
                        HStack {
                            Text(item.name)

                            Spacer()

                            Text(
                                item.price.formatted(
                                    .currency(code: "PKR")
                                )
                            )
                        }
                    }
                }

                // MARK: - Summary

                Section("Summary") {

                    if let subtotal = receipt.subtotal {
                        summaryRow(
                            title: "Subtotal",
                            value: subtotal
                        )
                    }

                    if let tax = receipt.tax {
                        summaryRow(
                            title: "Tax",
                            value: tax
                        )
                    }

                    HStack {
                        Text("Total")
                            .fontWeight(.bold)

                        Spacer()

                        Text(
                            receipt.total.formatted(
                                .currency(code: "PKR")
                            )
                        )
                        .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Receipt")
            .toolbarTitleDisplayMode(.inline)
//            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func summaryRow(
        title: String,
        value: Decimal
    ) -> some View {

        HStack {
            Text(title)

            Spacer()

            Text(
                value.formatted(
                    .currency(code: "PKR")
                )
            )
        }
    }
}
