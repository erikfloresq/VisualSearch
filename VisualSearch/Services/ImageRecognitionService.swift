import Vision
import UIKit

final class ImageRecognitionService {
    static let shared = ImageRecognitionService()
    private init() {}

    func recognize(image: UIImage) async -> [String] {
        guard let cgImage = image.cgImage else { return [] }

        async let ocrResults = recognizeText(in: cgImage)
        async let classResults = classifyImage(cgImage)

        let (ocr, classes) = await (ocrResults, classResults)
        print("OCR detectado: \(ocr)")
        print("Clasificación detectada: \(classes)")
        return Array(Set(ocr + classes))
    }

    private func recognizeText(in cgImage: CGImage) async -> [String] {
        await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, _ in
                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let texts = observations.compactMap { $0.topCandidates(1).first?.string }
                let words = texts
                    .flatMap { $0.components(separatedBy: CharacterSet.alphanumerics.inverted) }
                    .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
                    .filter { $0.count > 2 }
                continuation.resume(returning: words)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }

    private func classifyImage(_ cgImage: CGImage) async -> [String] {
        await withCheckedContinuation { continuation in
            let request = VNClassifyImageRequest { request, _ in
                let observations = request.results as? [VNClassificationObservation] ?? []
                let labels = observations
                    .filter { $0.confidence > 0.3 }
                    .prefix(10)
                    .map { $0.identifier.lowercased() }
                continuation.resume(returning: Array(labels))
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
}
