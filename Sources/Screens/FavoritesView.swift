import SwiftUI

struct FavoritesView: View {
    @Environment(AppState.self) private var app
    @State private var filter: ContentCategory?

    private var shown: [ContentItem] {
        let base = app.favorites
        guard let filter else { return base }
        return base.filter { $0.category == filter }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Space.lg) {
                    searchBar
                    chips
                    grid
                }
                .padding(.horizontal, Theme.Space.margin)
                .padding(.bottom, Theme.Space.xl)
            }
            .background(Theme.Palette.surface)
            .navigationTitle("Favorites")
            .navigationDestination(for: ContentItem.self) { ContentDetailView(item: $0) }
        }
    }

    private var searchBar: some View {
        HStack(spacing: Theme.Space.xs) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.Palette.outline)
            Text("Search your favorites...").font(.bodyLg).foregroundStyle(Theme.Palette.outline)
            Spacer()
        }
        .padding(Theme.Space.md)
        .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
    }

    private var chips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Theme.Space.sm) {
                FilterChip(title: "All Items", isSelected: filter == nil) { filter = nil }
                ForEach(ContentCategory.allCases) { c in
                    FilterChip(title: c.rawValue, isSelected: filter == c) { filter = c }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var grid: some View {
        VStack(spacing: Theme.Space.md) {
            if let hero = shown.first {
                NavigationLink(value: hero) { FavoriteHero(item: hero, isFav: app.isFavorite(hero)) }
                    .buttonStyle(.plain)
            }
            LazyVGrid(columns: [GridItem(.flexible(), spacing: Theme.Space.md),
                                GridItem(.flexible(), spacing: Theme.Space.md)],
                      spacing: Theme.Space.md) {
                ForEach(shown.dropFirst()) { item in
                    NavigationLink(value: item) { FavoriteCard(item: item) }
                        .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct FavoriteHero: View {
    let item: ContentItem
    let isFav: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.sm) {
            ZStack(alignment: .topTrailing) {
                Artwork(seed: item.artSeed, icon: item.icon, imageName: item.imageName).frame(height: 170)
                heartBadge(isFav).padding(Theme.Space.sm)
            }
            .clipShape(.rect(cornerRadius: Theme.Radius.card))
            TagBadge(text: item.category.rawValue)
            Text(item.title).font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            Text(item.summary).font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant).lineLimit(1)
        }
    }
}

private struct FavoriteCard: View {
    let item: ContentItem
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.xs) {
            ZStack(alignment: .topTrailing) {
                Artwork(seed: item.artSeed, icon: item.icon, imageName: item.imageName).frame(height: 110)
                heartBadge(true).padding(6)
            }
            .clipShape(.rect(cornerRadius: Theme.Radius.button))
            TagBadge(text: item.category.rawValue)
            Text(item.title).font(.callout).foregroundStyle(Theme.Palette.onSurface).lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private func heartBadge(_ filled: Bool) -> some View {
    Image(systemName: filled ? "heart.fill" : "heart")
        .font(.system(size: 12, weight: .bold))
        .foregroundStyle(Theme.Palette.secondary)
        .padding(7)
        .background(.white.opacity(0.92), in: .circle)
}
