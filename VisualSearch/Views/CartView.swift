import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var cart
    @Environment(Navigator.self) private var navigator
    @State private var showOrderConfirmation = false

    var body: some View {
        NavigationStack {
            Group {
                if cart.items.isEmpty {
                    emptyState
                } else {
                    cartList
                }
            }
            .navigationTitle("My Cart")
            .navigationBarTitleDisplayMode(.large)
            .alert("Order Placed! 🎉", isPresented: $showOrderConfirmation) {
                Button("Great!", role: .cancel) { cart.clear() }
            } message: {
                Text("Your order of \(cart.formattedTotal) will arrive in 30–45 minutes.")
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Your cart is empty", systemImage: "cart")
        } description: {
            Text("Browse FreshMart or use Visual Intelligence\nto find products with your camera.")
        }
    }

    private var cartList: some View {
        VStack(spacing: 0) {
            List {
                ForEach(cart.items) { item in
                    CartItemRow(item: item)
                }
                .onDelete { indexSet in
                    indexSet.forEach { cart.remove(cart.items[$0].product) }
                }
            }
            .listStyle(.plain)

            // Order summary footer
            VStack(spacing: 16) {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(cart.formattedTotal)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Text("\(cart.totalItems) item\(cart.totalItems == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)

                Button {
                    showOrderConfirmation = true
                } label: {
                    Text("Place Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(.white)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            .background(.background)
        }
    }
}

private struct CartItemRow: View {
    let item: CartStore.CartItem
    @Environment(CartStore.self) private var cart

    var body: some View {
        HStack(spacing: 12) {
            Text(item.product.emoji)
                .font(.system(size: 40))
                .frame(width: 56, height: 56)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(item.product.pricePerUnit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                Button { cart.remove(item.product) } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(Color.green)
                        .font(.title3)
                }
                Text("\(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 20)
                Button { cart.add(item.product) } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Color.green)
                        .font(.title3)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let cart = CartStore()
    cart.add(ProductDatabase.shared.products[0])
    cart.add(ProductDatabase.shared.products[1])
    cart.add(ProductDatabase.shared.products[0])
    return CartView()
        .environment(cart)
        .environment(Navigator())
}
