import SwiftUI
import PhotosUI

struct StoreView: View {
    @Environment(Navigator.self) private var navigator
    @Environment(CartStore.self) private var cart
    @State private var selectedCategory: Product.Category? = nil
    @State private var searchText = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var isAnalyzing = false

    private var filteredProducts: [Product] {
        var products = ProductDatabase.shared.products
        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            products = products.filter {
                $0.name.lowercased().contains(query) ||
                $0.keywords.contains { $0.contains(query) }
            }
        }
        return products
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    categoryPicker
                    productGrid
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("FreshMart 🛒")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if isAnalyzing {
                            ProgressView()
                                .frame(width: 24, height: 24)
                        } else {
                            Image(systemName: "camera.viewfinder")
                                .fontWeight(.medium)
                        }
                    }
                    .disabled(isAnalyzing)
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                guard let newItem else { return }
                Task {
                    isAnalyzing = true
                    defer { isAnalyzing = false; selectedPhoto = nil }
                    guard let data = try? await newItem.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else { return }
                    let labels = await ImageRecognitionService.shared.recognize(image: image)
                    guard !labels.isEmpty else { return }
                    navigator.showSearch(labels: labels)
                }
            }
            .sheet(isPresented: Binding(
                get: { navigator.showProductDetail },
                set: { navigator.showProductDetail = $0 }
            )) {
                if let product = navigator.selectedProduct {
                    NavigationStack {
                        ProductDetailView(product: product)
                    }
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: Binding(
                get: { navigator.showSearchResults },
                set: { navigator.showSearchResults = $0 }
            )) {
                SearchResultsView(labels: navigator.searchLabels)
            }
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                categoryChip(label: "All", emoji: "🏪", selected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(Product.Category.allCases, id: \.self) { category in
                    categoryChip(
                        label: category.rawValue,
                        emoji: category.emoji,
                        selected: selectedCategory == category
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func categoryChip(label: String, emoji: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji)
                Text(label)
                    .fontWeight(selected ? .semibold : .regular)
            }
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(selected ? Color.green : Color(.systemGray6))
            .foregroundStyle(selected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var productGrid: some View {
        Group {
            if filteredProducts.isEmpty {
                ContentUnavailableView(
                    "No products found",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different search or category")
                )
                .frame(minHeight: 300)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredProducts) { product in
                        ProductCard(product: product) {
                            cart.add(product)
                        } onTap: {
                            navigator.selectedProduct = product
                            navigator.showProductDetail = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StoreView()
        .environment(Navigator())
        .environment(CartStore())
}
