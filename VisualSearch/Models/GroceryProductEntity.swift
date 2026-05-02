import AppIntents

struct GroceryProductEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Grocery Product"
    static var defaultQuery = GroceryEntityQuery()

    var id: String
    var name: String
    var emoji: String
    var price: Double
    var unit: String
    var category: String

    init(from product: Product) {
        id = product.id
        name = product.name
        emoji = product.emoji
        price = product.price
        unit = product.unit
        category = product.category.rawValue
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(emoji) \(name)",
            subtitle: "\(String(format: "$%.2f", price)) / \(unit)",
            image: DisplayRepresentation.Image(url: URL(string: "https://gduecommerce.blob.core.windows.net/gdu-multimedias/e4f2edc2-d4b2-4983-8e2c-9d1fd7562577.jpg")!)
        )
    }
}

struct GroceryEntityQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [GroceryProductEntity] {
        ProductDatabase.shared.products
            .filter { identifiers.contains($0.id) }
            .map(GroceryProductEntity.init(from:))
    }

    func suggestedEntities() async throws -> [GroceryProductEntity] {
        ProductDatabase.shared.products.prefix(8).map(GroceryProductEntity.init(from:))
    }
}
