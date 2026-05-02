import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(CartStore.self) private var cart
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero emoji
                ZStack {
                    Color(.systemGray6)
                    Text(product.emoji)
                        .font(.system(size: 120))
                }
                .frame(height: 260)

                VStack(alignment: .leading, spacing: 20) {
                    // Name + category badge
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(product.category.emoji + " " + product.category.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.12))
                                .foregroundStyle(Color.green)
                                .clipShape(Capsule())
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(product.formattedPrice)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("per \(product.unit)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    // Description
                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    // Availability badge
                    Label(product.isAvailable ? "In Stock" : "Out of Stock",
                          systemImage: product.isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(product.isAvailable ? Color.green : Color.red)

                    Spacer(minLength: 32)

                    // Cart controls
                    cartSection
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.title3)
                }
            }
        }
    }

    @ViewBuilder
    private var cartSection: some View {
        let qty = cart.quantity(for: product)
        VStack(spacing: 12) {
            if qty > 0 {
                HStack {
                    Text("In cart")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(qty) × \(product.formattedPrice)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack(spacing: 16) {
                    Button {
                        cart.remove(product)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.green)
                    }

                    Text("\(qty)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(minWidth: 40)
                        .multilineTextAlignment(.center)

                    Button {
                        cart.add(product)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.green)
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Button {
                cart.add(product)
            } label: {
                Label(qty == 0 ? "Add to Cart" : "Add One More", systemImage: "cart.badge.plus")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .background(product.isAvailable ? Color.green : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!product.isAvailable)
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: ProductDatabase.shared.products[0])
            .environment(CartStore())
    }
}
