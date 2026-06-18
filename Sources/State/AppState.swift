import Foundation
import SwiftUI

/// App-wide UI state: onboarding progress, content catalog, favorites.
@MainActor
@Observable
final class AppState {
    enum Phase { case welcome, paywall, main }

    var phase: Phase = .welcome
    let items: [ContentItem] = MockData.items
    private(set) var favoriteIDs: Set<UUID> = []

    /// Optional deep link to a detail screen - used by screenshot automation (-screen detail).
    var previewItem: ContentItem?
    var selectedTab = 0

    init() {
        // Seed a couple of favorites so the Favorites tab is populated on first run.
        favoriteIDs = Set(items.prefix(3).map(\.id))

        // Launch-argument driven initial state for deterministic screenshots / demos.
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "-screen"), i + 1 < args.count {
            switch args[i + 1] {
            case "welcome": phase = .welcome
            case "paywall": phase = .paywall
            case "detail": phase = .main; previewItem = items.first
            case "favorites": phase = .main; selectedTab = 1
            case "settings": phase = .main; selectedTab = 2
            default: phase = .main
            }
        }
    }

    var favorites: [ContentItem] { items.filter { favoriteIDs.contains($0.id) } }

    func isFavorite(_ item: ContentItem) -> Bool { favoriteIDs.contains(item.id) }

    func toggleFavorite(_ item: ContentItem) {
        if favoriteIDs.contains(item.id) { favoriteIDs.remove(item.id) }
        else { favoriteIDs.insert(item.id) }
    }

    func items(in category: ContentCategory?) -> [ContentItem] {
        guard let category else { return items }
        return items.filter { $0.category == category }
    }

    var continueWatching: [ContentItem] { items.filter { $0.progress > 0 } }
    var featured: [ContentItem] { items.filter { $0.isPremium }.prefix(3).map { $0 } }
    var latest: [ContentItem] { Array(items.suffix(2)) }
}
