import SwiftUI

/// Onboarding + VSL-style intro. Tapping the play button simulates a video sales letter;
/// "Continue to Premium" advances to the hard paywall.
struct WelcomeView: View {
    @Environment(AppState.self) private var app
    @State private var isPlaying = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: Theme.Space.lg) {
                    videoCard
                    headline
                    valueRow
                }
                .padding(.horizontal, Theme.Space.margin)
                .padding(.top, Theme.Space.lg)
                .padding(.bottom, 140)
            }
        }
        .background(Theme.Palette.surface)
        .safeAreaInset(edge: .bottom) { footer }
    }

    private var header: some View {
        HStack {
            Image(systemName: "chevron.left").font(.title3.weight(.semibold))
                .foregroundStyle(Theme.Palette.primary)
            Spacer()
            Text("Premium Content").font(.headlineMd).foregroundStyle(Theme.Palette.primary)
            Spacer()
            Image(systemName: "person.crop.circle").font(.title2)
                .foregroundStyle(Theme.Palette.onSurfaceVariant)
        }
        .padding(.horizontal, Theme.Space.margin)
        .padding(.vertical, Theme.Space.sm)
    }

    private var videoCard: some View {
        ZStack(alignment: .topTrailing) {
            Artwork(seed: 0, icon: "leaf.fill", imageName: "interiorWindow")
                .frame(height: 200)
                .clipShape(.rect(cornerRadius: Theme.Radius.card))
            TagBadge(text: "Intro", tint: Theme.Palette.secondary)
                .padding(Theme.Space.sm)
            Button { isPlaying.toggle() } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Theme.Palette.onSurface)
                    .frame(width: 64, height: 64)
                    .background(Theme.Palette.primaryContainer, in: .circle)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 200)
        .cardShadow()
    }

    private var headline: some View {
        VStack(spacing: Theme.Space.sm) {
            (Text("Unlock Your\n") + Text("Potential").foregroundStyle(Theme.Palette.primaryContainer))
                .font(.display)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Palette.onSurface)
            Text("Access exclusive insights and high-end workshops designed for your premium lifestyle.")
                .font(.bodyMd)
                .foregroundStyle(Theme.Palette.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
    }

    private var valueRow: some View {
        HStack(spacing: Theme.Space.md) {
            valueCard(icon: "star.fill", title: "Expert Led", subtitle: "Top-tier curated mentorship.")
            valueCard(icon: "sparkles", title: "Daily Flows", subtitle: "Radiant habits for every day.")
        }
    }

    private func valueCard(icon: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Space.xs) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(Theme.Palette.primary)
                .frame(width: 40, height: 40)
                .background(Theme.Palette.primaryContainer.opacity(0.25), in: .rect(cornerRadius: Theme.Radius.chip))
            Text(title).font(.callout).foregroundStyle(Theme.Palette.onSurface)
            Text(subtitle).font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Space.md)
        .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
    }

    private var footer: some View {
        VStack(spacing: Theme.Space.sm) {
            PrimaryButton(title: "Continue to Premium") { app.phase = .paywall }
            Button {
                app.phase = .main
            } label: {
                (Text("Already a member? ").foregroundStyle(Theme.Palette.onSurfaceVariant)
                 + Text("Log in").foregroundStyle(Theme.Palette.primary).bold())
                    .font(.bodyMd)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.Space.margin)
        .padding(.top, Theme.Space.md)
        .padding(.bottom, Theme.Space.xs)
        .background(.ultraThinMaterial)
    }
}
