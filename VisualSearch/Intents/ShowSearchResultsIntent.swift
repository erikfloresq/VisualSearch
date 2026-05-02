import AppIntents
import VisualIntelligence

// Invoked when the user taps "Search in FreshMart" inside Visual Intelligence.
// Opens the app and shows a full search results screen with all matching products.
@MainActor
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowSearchResultsIntent {
    static let openAppWhenRun: Bool = true

    var semanticContent: SemanticContentDescriptor

    @Dependency
    var navigator: Navigator

    func perform() async throws -> some IntentResult {
        navigator.showSearch(labels: semanticContent.labels, openCamera: true)
        return .result()
    }
}
