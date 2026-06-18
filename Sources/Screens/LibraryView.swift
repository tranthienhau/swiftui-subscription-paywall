import SwiftUI

struct LibraryView: View {
    @Environment(AppState.self) private var app
    @State private var search = ""
    @State private var filter: Filter = .featured

    enum Filter: String, CaseIterable, Identifiable {
        case featured = "Featured", newReleases = "New Releases", mostPopular = "Most Popular"
        var id: String { rawValue }
    }

    private var results: [ContentItem] {
        guard !search.isEmpty else { return [] }
        return app.items.filter {
            $0.title.localizedStandardContains(search) ||
            $0.author.localizedStandardContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Space.lg) {
                    intro
                    searchBar
                    chips
                    if search.isEmpty {
                        curatedPicks
                        favoritesCarousel
                        latestContent
                    } else {
                        searchResults
                    }
                }
                .padding(.horizontal, Theme.Space.margin)
                .padding(.bottom, Theme.Space.xl)
            }
            .background(Theme.Palette.surface)
            .navigationTitle("Premium Content")
            .navigationDestination(for: ContentItem.self) { ContentDetailView(item: $0) }
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("DISCOVERY").font(.labelLg).foregroundStyle(Theme.Palette.secondary)
            Text("Explore Your Library").font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
        }
    }

    private var searchBar: some View {
        HStack(spacing: Theme.Space.xs) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.Palette.outline)
            TextField("Search masterclasses...", text: $search)
                .font(.bodyLg).foregroundStyle(Theme.Palette.onSurface)
        }
        .padding(Theme.Space.md)
        .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
    }

    private var chips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Theme.Space.sm) {
                ForEach(Filter.allCases) { f in
                    FilterChip(title: f.rawValue, isSelected: filter == f) { filter = f }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var curatedPicks: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            sectionHeader("Curated Picks", action: "View all")
            if let hero = app.items.first {
                NavigationLink(value: hero) { FeaturedCard(item: hero) }
                    .buttonStyle(.plain)
            }
            HStack(spacing: Theme.Space.md) {
                ForEach(app.items.dropFirst().prefix(2)) { item in
                    NavigationLink(value: item) { GridCard(item: item) }
                        .buttonStyle(.plain)
                }
            }
        }
    }

    private var favoritesCarousel: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            Label("Your Favorites", systemImage: "heart.fill")
                .font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
                .labelStyle(.titleAndIcon)
            ScrollView(.horizontal) {
                HStack(spacing: Theme.Space.md) {
                    ForEach(app.continueWatching) { item in
                        NavigationLink(value: item) { ContinueCard(item: item) }
                            .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var latestContent: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            Text("Latest Content").font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            ForEach(app.latest) { item in
                NavigationLink(value: item) { RowCard(item: item) }
                    .buttonStyle(.plain)
            }
        }
    }

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            Text("\(results.count) result(s)").font(.labelLg)
                .foregroundStyle(Theme.Palette.onSurfaceVariant)
            ForEach(results) { item in
                NavigationLink(value: item) { RowCard(item: item) }
                    .buttonStyle(.plain)
            }
        }
    }

    private func sectionHeader(_ title: String, action: String) -> some View {
        HStack {
            Text(title).font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            Spacer()
            Text(action + " ›").font(.labelLg).foregroundStyle(Theme.Palette.primary)
        }
    }
}

// MARK: - Cards

private struct FeaturedCard: View {
    let item: ContentItem
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Artwork(seed: item.artSeed, icon: item.icon).frame(height: 180)
            LinearGradient(colors: [.clear, .black.opacity(0.55)],
                           startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(item.category.rawValue) • \(item.duration)")
                    .font(.labelLg).foregroundStyle(Theme.Palette.primaryContainer)
                Text(item.title).font(.headlineMd).foregroundStyle(.white)
            }
            .padding(Theme.Space.md)
            if item.isPremium {
                TagBadge(text: "Premium", tint: Theme.Palette.primaryContainer)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(Theme.Space.sm)
            }
        }
        .frame(height: 180)
        .clipShape(.rect(cornerRadius: Theme.Radius.card))
        .cardShadow()
    }
}

private struct GridCard: View {
    let item: ContentItem
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.xs) {
            ZStack(alignment: .topTrailing) {
                Artwork(seed: item.artSeed, icon: item.icon).frame(height: 110)
                if item.isPremium { LockBadge().padding(6) }
            }
            .clipShape(.rect(cornerRadius: Theme.Radius.button))
            Text(item.title).font(.callout).foregroundStyle(Theme.Palette.onSurface)
                .lineLimit(1)
            Text("\(item.author) • \(item.meta)").font(.bodyMd)
                .foregroundStyle(Theme.Palette.onSurfaceVariant).lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ContinueCard: View {
    let item: ContentItem
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Space.xs) {
            ZStack(alignment: .topLeading) {
                Artwork(seed: item.artSeed, icon: item.icon).frame(width: 220, height: 120)
                TagBadge(text: "Continue", tint: Theme.Palette.secondary).padding(8)
            }
            .clipShape(.rect(cornerRadius: Theme.Radius.button))
            Text(item.title).font(.callout).foregroundStyle(Theme.Palette.onSurface).lineLimit(1)
            ProgressView(value: item.progress).tint(Theme.Palette.secondary)
            Text("\(Int(item.progress * 100))% Complete").font(.bodyMd)
                .foregroundStyle(Theme.Palette.onSurfaceVariant)
        }
        .frame(width: 220)
    }
}

private struct RowCard: View {
    let item: ContentItem
    var body: some View {
        HStack(spacing: Theme.Space.md) {
            Artwork(seed: item.artSeed, icon: item.icon)
                .frame(width: 64, height: 64)
                .clipShape(.rect(cornerRadius: Theme.Radius.chip))
            VStack(alignment: .leading, spacing: 4) {
                TagBadge(text: item.category.rawValue)
                Text(item.title).font(.callout).foregroundStyle(Theme.Palette.onSurface).lineLimit(1)
                Text("\(item.duration) • \(item.meta)").font(.bodyMd)
                    .foregroundStyle(Theme.Palette.onSurfaceVariant)
            }
            Spacer()
            Image(systemName: item.isPremium ? "lock.fill" : "play.circle.fill")
                .font(.title2).foregroundStyle(Theme.Palette.primary)
        }
        .padding(Theme.Space.sm)
        .background(Theme.Palette.surfaceContainerLowest, in: .rect(cornerRadius: Theme.Radius.button))
        .cardShadow()
    }
}
