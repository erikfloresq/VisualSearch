import SwiftUI

@Observable
final class CartStore {
    private(set) var items: [CartItem] = []

    struct CartItem: Identifiable {
        let id = UUID()
        let product: Product
        var quantity: Int
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var formattedTotal: String {
        String(format: "$%.2f", totalPrice)
    }

    func add(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func remove(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func quantity(for product: Product) -> Int {
        items.first { $0.product.id == product.id }?.quantity ?? 0
    }

    func clear() {
        items.removeAll()
    }
}
