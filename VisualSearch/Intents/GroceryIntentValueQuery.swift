import AppIntents
import VisualIntelligence

// Called by the system when Visual Intelligence captures an image and needs
// to know if your app has matching content. The SemanticContentDescriptor
// carries text labels describing what was detected in the photo.
struct GroceryIntentValueQuery: IntentValueQuery {
    typealias Value = GroceryProductEntity

    func values(for input: SemanticContentDescriptor) async throws -> [GroceryProductEntity] {
        let labels = input.labels
        print("VI Labels recibidos: \(labels)")
        return ProductMatchingService.shared.findProducts(matching: labels)
    }
}
