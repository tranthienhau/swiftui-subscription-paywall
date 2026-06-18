import SwiftUI

@main
struct RadiantLifeApp: App {
    @State private var app = AppState()
    @State private var subs = SubscriptionManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(app)
                .environment(subs)
                .tint(Theme.Palette.tertiary)
        }
    }
}

/// Drives the onboarding -> hard paywall -> main app gate.
struct RootView: View {
    @Environment(AppState.self) private var app
    @Environment(SubscriptionManager.self) private var subs

    var body: some View {
        Group {
            switch app.phase {
            case .welcome: WelcomeView()
            case .paywall: PaywallView()
            case .main:
                if let item = app.previewItem {
                    NavigationStack { ContentDetailView(item: item) }
                } else {
                    MainTabView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: app.phase)
        .animation(.easeInOut(duration: 0.4), value: app.selectedTab)
        .task { await runDemoIfNeeded() }
    }

    /// Auto-tour for recording a demo GIF: cycles every key screen with smooth transitions.
    private func runDemoIfNeeded() async {
        guard ProcessInfo.processInfo.arguments.contains("-demo") else { return }
        func step(_ s: Double) async { try? await Task.sleep(for: .seconds(s)) }
        while !Task.isCancelled {
            app.previewItem = nil; subs.setSubscribed(false)
            app.phase = .welcome;  await step(2.6)
            app.phase = .paywall;  await step(2.8)
            app.phase = .main; app.selectedTab = 0; await step(2.6)
            subs.setSubscribed(true); app.previewItem = app.items.first; await step(3.0)
            app.previewItem = nil; app.selectedTab = 1; await step(2.6)
            app.selectedTab = 2; await step(2.6)
        }
    }
}

struct MainTabView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        @Bindable var app = app
        TabView(selection: $app.selectedTab) {
            Tab("Library", systemImage: "square.stack.fill", value: 0) { LibraryView() }
            Tab("Favorites", systemImage: "heart.fill", value: 1) { FavoritesView() }
            Tab("Settings", systemImage: "gearshape.fill", value: 2) { SettingsView() }
        }
        .tint(Theme.Palette.primary)
    }
}
