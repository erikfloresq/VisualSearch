import SwiftUI
import AppIntents

@main
struct VisualSearchApp: App {
    private let navigator = Navigator()
    private let cart = CartStore()

    init() {
        // Register shared dependencies so AppIntents (OpenProductIntent,
        // ShowSearchResultsIntent) can resolve them without the UI being active.
        let nav = navigator
        AppDependencyManager.shared.add(dependency: nav)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigator)
                .environment(cart)
        }
    }
}
