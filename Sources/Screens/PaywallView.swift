import SwiftUI

/// Hard paywall - no dismiss path except completing the trial. Annual plan, 3-day free trial.
struct PaywallView: View {
    @Environment(AppState.self) private var app
    @Environment(SubscriptionManager.self) private var subs
    @State private var restoreMessage: String?

    private let perks: [(String, String, String)] = [
        ("infinity", "Unlimited Access", "Every article, video, and guide."),
        ("checkmark.seal.fill", "Exclusive Content", "Member-only deep dives."),
        ("arrow.down.circle.fill", "Offline Mode", "Download for on-the-go."),
        ("tv.fill", "Ad-Free Experience", "Pure, uninterrupted focus."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: Theme.Space.lg) {
                    hero
                    title
                    perksGrid
                    planCard
                    legal
                }
                .padding(.horizontal, Theme.Space.margin)
                .padding(.bottom, Theme.Space.xl)
            }
        }
        .background(Theme.Palette.surface)
        .alert("Restore Purchases", isPresented: .constant(restoreMessage != nil)) {
            Button("OK") { restoreMessage = nil }
        } message: { Text(restoreMessage ?? "") }
        .onChange(of: subs.isSubscribed) { _, subscribed in
            if subscribed { app.phase = .main }
        }
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

    private var hero: some View {
        ZStack(alignment: .topLeading) {
            Artwork(seed: 2, icon: "books.vertical.fill")
                .frame(height: 180)
                .clipShape(.rect(cornerRadius: Theme.Radius.card))
            TagBadge(text: "★ Premium Access", tint: Theme.Palette.onSurface)
                .padding(Theme.Space.sm)
        }
        .cardShadow()
    }

    private var title: some View {
        VStack(spacing: Theme.Space.xs) {
            Text("Unlock the Full Experience")
                .font(.headlineLg).foregroundStyle(Theme.Palette.onSurface)
                .multilineTextAlignment(.center)
            Text("Join our community and get access to exclusive content designed for your premium lifestyle.")
                .font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
    }

    private var perksGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: Theme.Space.md),
                            GridItem(.flexible(), spacing: Theme.Space.md)],
                  spacing: Theme.Space.md) {
            ForEach(perks, id: \.1) { perk in
                VStack(spacing: Theme.Space.xs) {
                    Image(systemName: perk.0)
                        .font(.title2).foregroundStyle(Theme.Palette.primary)
                        .frame(width: 48, height: 48)
                        .background(Theme.Palette.primaryContainer.opacity(0.22), in: .circle)
                    Text(perk.1).font(.callout).foregroundStyle(Theme.Palette.onSurface)
                    Text(perk.2).font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Space.md)
                .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
            }
        }
    }

    private var planCard: some View {
        VStack(spacing: Theme.Space.sm) {
            HStack {
                Spacer()
                Text("BEST VALUE")
                    .font(.system(size: 11, weight: .heavy)).tracking(0.5)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Theme.Palette.primaryContainer, in: .rect(cornerRadius: 8))
            }
            Text(subs.annual.title.uppercased())
                .font(.labelLg).foregroundStyle(Theme.Palette.primary)
            (Text(subs.annual.priceText).font(.system(size: 36, weight: .heavy, design: .rounded))
             + Text(" / year").font(.bodyLg))
                .foregroundStyle(Theme.Palette.onSurface)
            Text("\(subs.annual.trialDays)-Day Free Trial Included")
                .font(.labelLg).foregroundStyle(Theme.Palette.secondary)
                .padding(.horizontal, Theme.Space.md).padding(.vertical, 6)
                .background(Theme.Palette.secondaryContainer.opacity(0.18), in: .capsule)
            Text("Just \(subs.annual.perMonthText) per month, billed annually.")
                .font(.bodyMd).italic().foregroundStyle(Theme.Palette.onSurfaceVariant)

            PrimaryButton(title: subs.isPurchasing ? "Processing..." : "Start Free Trial") {
                Task { await subs.startFreeTrial() }
            }
            .disabled(subs.isPurchasing)
            .padding(.top, Theme.Space.xs)
        }
        .padding(Theme.Space.lg)
        .background(Theme.Palette.surfaceContainerLowest, in: .rect(cornerRadius: Theme.Radius.card))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .stroke(Theme.Palette.primaryContainer, lineWidth: 2)
        )
        .cardShadow()
    }

    private var legal: some View {
        VStack(spacing: Theme.Space.sm) {
            Button("Restore Purchases") {
                Task {
                    let ok = await subs.restorePurchases()
                    restoreMessage = ok ? "Your subscription was restored."
                                        : "No previous purchases found."
                }
            }
            .font(.callout).foregroundStyle(Theme.Palette.primary)

            HStack(spacing: Theme.Space.xs) {
                Text("Terms of Service")
                Text("•")
                Text("Privacy Policy")
            }
            .font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)

            Text("Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                .font(.system(size: 11)).foregroundStyle(Theme.Palette.outline)
                .multilineTextAlignment(.center)
        }
    }
}
