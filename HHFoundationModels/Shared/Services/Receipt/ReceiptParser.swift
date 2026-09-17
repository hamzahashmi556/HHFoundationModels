////
////  ReceiptParser.swift
////  HHFoundationModels
////
////  Created by PSG-MDU-HAMZA on 16/09/2026.
////
//
//import Foundation
//
//
//final class ReceiptParser: ReceiptParserProtocol {
//
//    func parse(lines: [String]) throws -> Receipt {
//
//        let cleanedLines = lines
//            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//            .filter { !$0.isEmpty }
//
//        let merchant = extractMerchant(from: cleanedLines)
//        let date = extractDate(from: cleanedLines)
//        let items = extractItems(from: cleanedLines)
//
//        let subtotal = extractAmount(
//            after: ["SUB TOTAL", "SUBTOTAL"],
//            from: cleanedLines
//        )
//
//        let tax = extractAmount(
//            after: ["TAX", "GST"],
//            from: cleanedLines
//        )
//
//        guard let total = extractAmount(
//            after: ["TOTAL", "GRAND TOTAL"],
//            from: cleanedLines
//        ) else {
//            throw ReceiptParserError.totalNotFound
//        }
//
//        return Receipt(
//            id: UUID(),
//            merchant: merchant,
//            date: date,
//            items: items,
//            subtotal: subtotal,
//            tax: tax,
//            total: total
//        )
//    }
//}
//
//private extension ReceiptParser {
//
//    func extractMerchant(from lines: [String]) -> String {
//
//        guard let firstLine = lines.first else {
//            return "Unknown Merchant"
//        }
//
//        return firstLine
//    }
//}
//
//private extension ReceiptParser {
//
//    func extractAmount(
//        after keywords: [String],
//        from lines: [String]
//    ) -> Decimal? {
//
//        for line in lines {
//
//            let normalized = line.uppercased()
//
//            for keyword in keywords {
//
//                guard normalized.contains(keyword) else {
//                    continue
//                }
//
//                let remaining = normalized
//                    .replacingOccurrences(
//                        of: keyword,
//                        with: ""
//                    )
//
//                if let amount = extractDecimal(from: remaining) {
//                    return amount
//                }
//            }
//        }
//
//        return nil
//    }
//
//    func extractDecimal(from text: String) -> Decimal? {
//
//        let pattern = #"\d+(?:[.,]\d{1,2})?"#
//
//        guard let regex = try? NSRegularExpression(
//            pattern: pattern
//        ) else {
//            return nil
//        }
//
//        let range = NSRange(
//            text.startIndex..<text.endIndex,
//            in: text
//        )
//
//        guard let match = regex.firstMatch(
//            in: text,
//            range: range
//        ) else {
//            return nil
//        }
//
//        guard let matchRange = Range(
//            match.range,
//            in: text
//        ) else {
//            return nil
//        }
//
//        let value = text[matchRange]
//            .replacingOccurrences(of: ",", with: "")
//
//        return Decimal(string: value)
//    }
//}
//
//private extension ReceiptParser {
//
//    func extractItems(from lines: [String]) -> [ReceiptItem] {
//
//        var items: [ReceiptItem] = []
//
//        let ignoredKeywords = [
//            "TOTAL",
//            "SUBTOTAL",
//            "SUB TOTAL",
//            "TAX",
//            "GST",
//            "CHANGE",
//            "CASH",
//            "CARD"
//        ]
//
//        for line in lines {
//
//            let uppercased = line.uppercased()
//
//            if ignoredKeywords.contains(where: {
//                uppercased.contains($0)
//            }) {
//                continue
//            }
//
//            guard let match = parseItemLine(line) else {
//                continue
//            }
//
//            items.append(
//                ReceiptItem(
//                    id: UUID(),
//                    name: match.name,
//                    price: match.price
//                )
//            )
//        }
//
//        return items
//    }
//
//    func parseItemLine(
//        _ line: String
//    ) -> (name: String, price: Decimal)? {
//
//        let pattern = #"^(.+?)\s+(\d+(?:[.,]\d{1,2})?)$"#
//
//        guard let regex = try? NSRegularExpression(
//            pattern: pattern
//        ) else {
//            return nil
//        }
//
//        let range = NSRange(
//            line.startIndex..<line.endIndex,
//            in: line
//        )
//
//        guard let match = regex.firstMatch(
//            in: line,
//            range: range
//        ) else {
//            return nil
//        }
//
//        guard
//            let nameRange = Range(match.range(at: 1), in: line),
//            let priceRange = Range(match.range(at: 2), in: line)
//        else {
//            return nil
//        }
//
//        let name = String(line[nameRange])
//            .trimmingCharacters(in: .whitespaces)
//
//        let priceString = String(line[priceRange])
//            .replacingOccurrences(of: ",", with: "")
//
//        guard let price = Decimal(string: priceString) else {
//            return nil
//        }
//
//        return (name, price)
//    }
//}
