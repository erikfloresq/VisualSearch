import Foundation

// Matches Visual Intelligence labels against the product catalog.
// Labels come from SemanticContentDescriptor.labels — natural-language strings
// like "apple", "red fruit", "dairy product", etc.
final class ProductMatchingService: Sendable {
    static let shared = ProductMatchingService()

    private init() {}

    func findProducts(matching labels: [String]) -> [GroceryProductEntity] {
        guard !labels.isEmpty else { return [] }

        let normalizedLabels = labels.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
        let products = ProductDatabase.shared.products.filter(\.isAvailable)

        var scored: [(product: Product, score: Int)] = products.compactMap { product in
            let score = relevanceScore(for: product, labels: normalizedLabels)
            return score > 0 ? (product, score) : nil
        }

        scored.sort { $0.score > $1.score }

        return scored
            .filter { $0.score >= 5 }
            .prefix(3)
            .map { GroceryProductEntity(from: $0.product) }
    }

    private func relevanceScore(for product: Product, labels: [String]) -> Int {
        var score = 0
        let productName = product.name.lowercased()
        let categoryName = product.category.rawValue.lowercased()
        let productKeywords = product.keywords.map { $0.lowercased() }

        for label in labels {
            // Exact name match is the strongest signal
            if productName == label { score += 20 }
            else if productName.contains(label) || label.contains(productName) { score += 10 }

            // Category match
            if categoryName.contains(label) || label.contains(categoryName) { score += 5 }

            // Keyword matches
            for keyword in productKeywords {
                if keyword == label { score += 8 }
                else if keyword.contains(label) || label.contains(keyword) { score += 4 }
            }

            // Emoji can also match in some edge cases
            if product.emoji == label { score += 15 }
        }

        return score
    }
}
