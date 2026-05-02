import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let category: Category
    let price: Double
    let unit: String
    let description: String
    let keywords: [String]
    var isAvailable: Bool

    enum Category: String, Codable, CaseIterable {
        case fruits = "Fruits"
        case vegetables = "Vegetables"
        case dairy = "Dairy"
        case bakery = "Bakery"
        case beverages = "Beverages"
        case snacks = "Snacks"

        var emoji: String {
            switch self {
            case .fruits: "🍎"
            case .vegetables: "🥦"
            case .dairy: "🥛"
            case .bakery: "🍞"
            case .beverages: "🧃"
            case .snacks: "🍿"
            }
        }
    }

    var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    var pricePerUnit: String {
        "\(formattedPrice) / \(unit)"
    }
}
