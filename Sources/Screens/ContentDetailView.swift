import SwiftUI

/// Individual content detail. Premium items are gated: when not subscribed the player and
/// download show a lock + paywall trigger; locked lessons stay disabled.
struct ContentDetailView: View {
    let item: ContentItem
    @Environment(AppState.self) private var app
    @Environment(SubscriptionManager.self) private var subs
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    private var locked: Bool { item.isPremium && !subs.isSubscribed }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Space.lg) {
                player
                meta
                Text(item.summary).font(.bodyLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
                downloadButton
                lessonList
                dailyInspiration
            }
            .padding(.horizontal, Theme.Space.margin)
            .padding(.bottom, Theme.Space.xl)
        }
        .background(Theme.Palette.surface)
        .navigationTitle("Radiant Life")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { app.toggleFavorite(item) } label: {
                    Image(systemName: app.isFavorite(item) ? "heart.fill" : "heart")
                        .foregroundStyle(Theme.Palette.secondary)
                }
            }
        }
        .sheet(isPresented: $showPaywall) { PaywallSheet() }
    }

    private var player: some View {
        ZStack {
            Artwork(seed: item.artSeed, icon: item.icon).frame(height: 200)
            Image(systemName: locked ? "lock.fill" : "play.fill")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.Palette.onSurface)
                .frame(width: 64, height: 64)
                .background(Theme.Palette.primaryContainer, in: .circle)
            VStack {
                Spacer()
                HStack {
                    Text(item.duration).font(.labelLg)
                    Spacer()
                    Label(item.meta, systemImage: "rectangle.on.rectangle").font(.labelLg)
                }
                .foregroundStyle(.white)
                .padding(Theme.Space.sm)
                .background(.black.opacity(0.25))
            }
        }
        .frame(height: 200)
        .clipShape(.rect(cornerRadius: Theme.Radius.card))
        .cardShadow()
    }

    private var meta: some View {
        VStack(alignment: .leading, spacing: Theme.Space.xs) {
            HStack(spacing: Theme.Space.xs) {
                TagBadge(text: item.kind, tint: Theme.Palette.primary)
                Text(item.duration).font(.labelLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
            }
            Text(item.title).font(.headlineLg).foregroundStyle(Theme.Palette.onSurface)
        }
    }

    @ViewBuilder private var downloadButton: some View {
        if locked {
            PrimaryButton(title: "Unlock with Premium", systemImage: "lock.open.fill") {
                showPaywall = true
            }
        } else {
            PrimaryButton(title: "Download for Offline", systemImage: "arrow.down.to.line") {}
        }
    }

    private var lessonList: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            Text("Lesson Content").font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            ForEach(item.lessons) { lesson in
                lessonRow(lesson)
            }
        }
    }

    private func lessonRow(_ lesson: Lesson) -> some View {
        let lessonLocked = lesson.isLocked && !subs.isSubscribed
        return HStack(spacing: Theme.Space.md) {
            Text("\(lesson.index)")
                .font(.callout.weight(.bold))
                .foregroundStyle(lessonLocked ? Theme.Palette.outline : Theme.Palette.primary)
                .frame(width: 36, height: 36)
                .background(Theme.Palette.primaryContainer.opacity(lessonLocked ? 0.1 : 0.25),
                            in: .rect(cornerRadius: Theme.Radius.chip))
            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.title).font(.callout)
                    .foregroundStyle(lessonLocked ? Theme.Palette.outline : Theme.Palette.onSurface)
                Text("\(lesson.subtitle) • \(lesson.duration)").font(.bodyMd)
                    .foregroundStyle(Theme.Palette.onSurfaceVariant)
            }
            Spacer()
            Image(systemName: lessonLocked ? "lock.fill" : "play.circle")
                .font(.title3).foregroundStyle(Theme.Palette.primary)
        }
        .padding(Theme.Space.sm)
        .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
    }

    private var dailyInspiration: some View {
        VStack(alignment: .leading, spacing: Theme.Space.md) {
            Text("Daily Inspiration").font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            ZStack(alignment: .bottomLeading) {
                Artwork(seed: 3, icon: "cup.and.saucer.fill").frame(height: 120)
                LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .center, endPoint: .bottom)
                VStack(alignment: .leading, spacing: 2) {
                    Text("ARTICLE").font(.labelLg).foregroundStyle(Theme.Palette.primaryContainer)
                    Text("Rituals for Calm").font(.headlineMd).foregroundStyle(.white)
                }
                .padding(Theme.Space.md)
            }
            .frame(height: 120)
            .clipShape(.rect(cornerRadius: Theme.Radius.card))
            HStack(spacing: Theme.Space.md) {
                inspoCard("Focus Flow", "Spotify Playlist", "music.note", Theme.Palette.secondaryContainer)
                inspoCard("Zen Space", "Decoration Guide", "leaf.fill", Theme.Palette.tertiaryContainer)
            }
        }
    }

    private func inspoCard(_ title: String, _ subtitle: String, _ icon: String, _ tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon).foregroundStyle(Theme.Palette.onSurface)
            Text(title).font(.callout).foregroundStyle(Theme.Palette.onSurface)
            Text(subtitle).font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Space.md)
        .background(tint.opacity(0.25), in: .rect(cornerRadius: Theme.Radius.button))
    }
}

/// Paywall presented as a dismissible sheet from a locked detail (vs. the hard onboarding gate).
private struct PaywallSheet: View {
    @Environment(SubscriptionManager.self) private var subs
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: Theme.Space.lg) {
            Capsule().fill(Theme.Palette.outlineVariant).frame(width: 40, height: 5).padding(.top, Theme.Space.sm)
            Image(systemName: "crown.fill").font(.system(size: 44)).foregroundStyle(Theme.Palette.primaryContainer)
            Text("Go Premium").font(.headlineLg).foregroundStyle(Theme.Palette.onSurface)
            Text("\(subs.annual.priceText)/year · \(subs.annual.trialDays)-day free trial")
                .font(.bodyLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
            PrimaryButton(title: subs.isPurchasing ? "Processing..." : "Start Free Trial") {
                Task { await subs.startFreeTrial(); dismiss() }
            }
            .disabled(subs.isPurchasing)
            Button("Maybe later") { dismiss() }
                .font(.callout).foregroundStyle(Theme.Palette.onSurfaceVariant)
            Spacer()
        }
        .padding(Theme.Space.lg)
        .presentationDetents([.medium])
        .background(Theme.Palette.surface)
    }
}
