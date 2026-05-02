import AppIntents

// Invoked when the user taps a product result card inside Visual Intelligence.
// Opens the app and navigates directly to that product's detail view.
struct OpenProductIntent: OpenIntent {
    static var title: LocalizedStringResource = "Open Grocery Product"

    @Parameter(title: "Product")
    var target: GroceryProductEntity

    @Dependency
    var navigator: Navigator

    func perform() async throws -> some IntentResult {
        navigator.openProduct(withId: target.id)
        return .result()
    }
}
