import SwiftUI

struct ProductCard: View {
    let product: Product
    let onAdd: () -> Void
    let onTap: () -> Void

    @Environment(CartStore.self) private var cart

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Emoji thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                    Text(product.emoji)
                        .font(.system(size: 52))
                }
                .frame(height: 110)

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(product.pricePerUnit)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 8)

                    addButton
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.plain)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }

    @ViewBuilder
    private var addButton: some View {
        let qty = cart.quantity(for: product)
        if qty == 0 {
            Button(action: onAdd) {
                Label("Add", systemImage: "plus")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        } else {
            HStack(spacing: 0) {
                Button {
                    cart.remove(product)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 28, height: 28)
                }
                Text("\(qty)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Button {
                    cart.add(product)
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 28, height: 28)
                }
            }
            .font(.caption)
            .foregroundStyle(.white)
            .background(Color.green)
            .clipShape(Capsule())
        }
    }
}
