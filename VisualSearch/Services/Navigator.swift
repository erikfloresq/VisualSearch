import AppIntents
import SwiftUI

// Shared navigation state injected into SwiftUI environment and into AppIntents
// via AppDependencyManager so that intents can trigger UI navigation.
@Observable
final class Navigator: @unchecked Sendable {
    var selectedProduct: Product? = nil
    var showProductDetail: Bool = false
    var showSearchResults: Bool = false
    var searchLabels: [String] = []
    var openCameraOnSearch: Bool = false

    nonisolated required init() {}

    func openProduct(withId id: String) {
        guard let product = ProductDatabase.shared.product(withId: id) else { return }
        selectedProduct = product
        showProductDetail = true
    }

    func showSearch(labels: [String], openCamera: Bool = false) {
        searchLabels = labels
        openCameraOnSearch = openCamera
        showSearchResults = true
    }
}
