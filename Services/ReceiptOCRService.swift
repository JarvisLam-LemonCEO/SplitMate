import Foundation
import Vision
import UIKit

struct ReceiptOCRResult {
    let merchant: String?
    let total: Double?
}

struct ReceiptOCRService {
    static func scan(imageData: Data) async -> ReceiptOCRResult {
        guard let image = UIImage(data: imageData),
              let cgImage = image.cgImage else {
            return ReceiptOCRResult(merchant: nil, total: nil)
        }

        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, _ in
                let observations = request.results as? [VNRecognizedTextObservation] ?? []

                let lines = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }

                let merchant = lines.first
                let total = extractTotal(from: lines)

                continuation.resume(
                    returning: ReceiptOCRResult(
                        merchant: merchant,
                        total: total
                    )
                )
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage)

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(
                    returning: ReceiptOCRResult(merchant: nil, total: nil)
                )
            }
        }
    }

    private static func extractTotal(from lines: [String]) -> Double? {
        let keywords = ["total", "amount", "balance", "paid"]

        for line in lines.reversed() {
            let lower = line.lowercased()

            if keywords.contains(where: { lower.contains($0) }) {
                if let value = extractMoney(from: line) {
                    return value
                }
            }
        }

        for line in lines.reversed() {
            if let value = extractMoney(from: line) {
                return value
            }
        }

        return nil
    }

    private static func extractMoney(from text: String) -> Double? {
        let pattern = #"(\d+\.\d{2})"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let range = NSRange(text.startIndex..<text.endIndex, in: text)

        guard let match = regex.firstMatch(in: text, range: range),
              let amountRange = Range(match.range(at: 1), in: text) else {
            return nil
        }

        return Double(text[amountRange])
    }
}
