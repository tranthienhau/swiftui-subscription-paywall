import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var app
    @Environment(SubscriptionManager.self) private var subs
    @State private var restoreMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Space.xl) {
                    profile
                    section("Account") {
                        row("person.fill", "Personal Information", Theme.Palette.primaryContainer)
                        divider
                        row("lock.fill", "Password & Security", Theme.Palette.primaryContainer)
                        divider
                        row("bell.fill", "Notification Settings", Theme.Palette.primaryContainer)
                    }
                    subscriptionSection
                    section("Support") {
                        row("questionmark.circle.fill", "Contact Support", Theme.Palette.tertiaryContainer)
                        divider
                        row("doc.text.fill", "Terms of Service", Theme.Palette.tertiaryContainer)
                        divider
                        row("checkmark.shield.fill", "Privacy Policy", Theme.Palette.tertiaryContainer)
                    }
                    signOut
                    Text("Version 1.0 (Gold)").font(.bodyMd).foregroundStyle(Theme.Palette.outline)
                }
                .padding(.horizontal, Theme.Space.margin)
                .padding(.bottom, Theme.Space.xl)
            }
            .background(Theme.Palette.surface)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Restore Purchases", isPresented: .constant(restoreMessage != nil)) {
                Button("OK") { restoreMessage = nil }
            } message: { Text(restoreMessage ?? "") }
        }
    }

    private var profile: some View {
        VStack(spacing: Theme.Space.xs) {
            Image("avatar")
                .resizable().scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(.circle)
                .overlay(Circle().stroke(Theme.Palette.primaryContainer, lineWidth: 3))
            Text("Alex Rivera").font(.headlineMd).foregroundStyle(Theme.Palette.onSurface)
            Text("alex.rivera@premium.com").font(.bodyLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
        }
        .padding(.top, Theme.Space.md)
    }

    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: Theme.Space.sm) {
            Text("SUBSCRIPTION").font(.labelLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
            VStack(spacing: 0) {
                HStack(spacing: Theme.Space.md) {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(Theme.Palette.primary)
                        .frame(width: 40, height: 40)
                        .background(Theme.Palette.primaryContainer, in: .rect(cornerRadius: Theme.Radius.chip))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Premium Plan").font(.callout).foregroundStyle(Theme.Palette.onSurface)
                        Text(subs.isSubscribed ? subs.entitlementText : "No active subscription")
                            .font(.bodyMd).foregroundStyle(Theme.Palette.onSurfaceVariant)
                    }
                    Spacer()
                    Text(subs.isSubscribed ? "PRO" : "FREE")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Theme.Palette.primary, in: .capsule)
                }
                .padding(Theme.Space.md)
                .background(Theme.Palette.primaryContainer.opacity(0.18))
                divider
                row("creditcard.fill", "Manage Plan", Theme.Palette.secondaryContainer)
                divider
                Button {
                    Task {
                        let ok = await subs.restorePurchases()
                        restoreMessage = ok ? "Your subscription was restored."
                                            : "No previous purchases found."
                    }
                } label: {
                    rowContent("clock.arrow.circlepath", "Restore Purchases", Theme.Palette.secondaryContainer)
                }
                .buttonStyle(.plain)
            }
            .background(Theme.Palette.surfaceContainerLowest, in: .rect(cornerRadius: Theme.Radius.button))
            .cardShadow()
        }
    }

    private var signOut: some View {
        Button { app.phase = .welcome; subs.cancel() } label: {
            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.callout.weight(.bold))
                .foregroundStyle(Theme.Palette.error)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Theme.Palette.surfaceContainer, in: .rect(cornerRadius: Theme.Radius.button))
        }
        .buttonStyle(.plain)
    }

    // MARK: helpers

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Theme.Space.sm) {
            Text(title.uppercased()).font(.labelLg).foregroundStyle(Theme.Palette.onSurfaceVariant)
            VStack(spacing: 0) { content() }
                .background(Theme.Palette.surfaceContainerLowest, in: .rect(cornerRadius: Theme.Radius.button))
                .cardShadow()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(_ icon: String, _ title: String, _ tint: Color) -> some View {
        rowContent(icon, title, tint)
    }

    private func rowContent(_ icon: String, _ title: String, _ tint: Color) -> some View {
        HStack(spacing: Theme.Space.md) {
            Image(systemName: icon)
                .foregroundStyle(Theme.Palette.onSurface)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.4), in: .rect(cornerRadius: Theme.Radius.chip))
            Text(title).font(.bodyLg).foregroundStyle(Theme.Palette.onSurface)
            Spacer()
            Image(systemName: "chevron.right").font(.bodyMd).foregroundStyle(Theme.Palette.outline)
        }
        .padding(Theme.Space.md)
    }

    private var divider: some View {
        Rectangle().fill(Theme.Palette.outlineVariant.opacity(0.4)).frame(height: 1)
            .padding(.leading, 68)
    }
}
