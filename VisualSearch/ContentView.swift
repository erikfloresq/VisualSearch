import SwiftUI

struct ContentView: View {
    @Environment(CartStore.self) private var cart

    var body: some View {
        TabView {
            Tab("Store", systemImage: "storefront") {
                StoreView()
            }
            Tab("Cart", systemImage: "cart") {
                CartView()
            }
            .badge(cart.totalItems > 0 ? Text("\(cart.totalItems)") : nil)
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
        .environment(CartStore())
        .environment(Navigator())
}
