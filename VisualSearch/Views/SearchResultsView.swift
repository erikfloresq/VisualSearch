import SwiftUI
import PhotosUI

// Presented when the user taps "Search in FreshMart" from Visual Intelligence.
// Shows all products that matched the captured image's labels.
struct SearchResultsView: View {
    let labels: [String]
    @Environment(CartStore.self) private var cart
    @Environment(Navigator.self) private var navigator
    @Environment(\.dismiss) private var dismiss

    @State private var activeLabels: [String] = []
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var isAnalyzing = false
    @State private var showPhotoPicker = false

    private var matchedProducts: [Product] {
        let entities = ProductMatchingService.shared.findProducts(matching: activeLabels)
        let ids = entities.map(\.id)
        return ids.compactMap { ProductDatabase.shared.product(withId: $0) }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if matchedProducts.isEmpty {
                    noResultsView
                } else {
                    resultsGrid
                }
            }
            .navigationTitle("Visual Search Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                activeLabels = labels
                if navigator.openCameraOnSearch {
                    navigator.openCameraOnSearch = false
                    Task {
                        try? await Task.sleep(for: .milliseconds(700))
                        showPhotoPicker = true
                    }
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
            .onChange(of: selectedPhoto) { _, newItem in
                guard let newItem else { return }
                Task {
                    isAnalyzing = true
                    defer { isAnalyzing = false; selectedPhoto = nil }
                    guard let data = try? await newItem.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else { return }
                    let ocrLabels = await ImageRecognitionService.shared.recognize(image: image)
                    guard !ocrLabels.isEmpty else { return }
                    activeLabels = ocrLabels
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
        }
    }

    private var resultsGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Detected labels banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Detected in photo", systemImage: "camera.viewfinder")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button {
                            showPhotoPicker = true
                        } label: {
                            if isAnalyzing {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Label("Improve results", systemImage: "camera.badge.plus")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                        .disabled(isAnalyzing)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(activeLabels, id: \.self) { label in
                                Text(label)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.green.opacity(0.12))
                                    .foregroundStyle(Color.green)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Text("\(matchedProducts.count) product\(matchedProducts.count == 1 ? "" : "s") found")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(matchedProducts) { product in
                        ProductCard(product: product) {
                            cart.add(product)
                        } onTap: {
                            navigator.selectedProduct = product
                            navigator.showProductDetail = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }

    private var noResultsView: some View {
        ContentUnavailableView {
            Label("No matches found", systemImage: "camera.viewfinder")
        } description: {
            Text("FreshMart doesn't carry products matching the captured image. Try scanning a clearer photo for better results.")
        } actions: {
            Button {
                showPhotoPicker = true
            } label: {
                if isAnalyzing {
                    ProgressView()
                } else {
                    Label("Scan photo", systemImage: "camera.badge.plus")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(isAnalyzing)

            Button("Browse Store") { dismiss() }
                .buttonStyle(.bordered)
        }
    }
}

#Preview {
    SearchResultsView(labels: ["apple", "red fruit", "fruit"])
        .environment(CartStore())
        .environment(Navigator())
}
