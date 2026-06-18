import Foundation
import SwiftUI

/// Subscription gateway. In production this is backed by RevenueCat (`Purchases.shared`)
/// or StoreKit 2 (`Product.products(for:)` + `product.purchase()`); here the calls are
/// simulated so the paywall flow is fully demoable on a simulator with no IAP sandbox.
@MainActor
@Observable
final class SubscriptionManager {
    /// Mirrors a StoreKit `Product` / RevenueCat `Package`.
    struct Plan {
        let id: String
        let title: String
        let priceText: String          // localized display price
        let perMonthText: String
        let trialDays: Int
    }

    let annual = Plan(
        id: "com.tranthienhau.radiantlife.annual",
        title: "Annual Subscription",
        priceText: "$99.99",
        perMonthText: "$8.33",
        trialDays: 3
    )

    private(set) var isSubscribed = false
    private(set) var isInTrial = false
    private(set) var isPurchasing = false

    init() {
        // Screenshot/demo override: launch with -subscribed to start entitled.
        if ProcessInfo.processInfo.arguments.contains("-subscribed") {
            isSubscribed = true
        }
    }

    var entitlementText: String {
        isInTrial ? "Free Trial - active" : "Premium Plan - Active until Dec 2026"
    }

    /// Simulates `product.purchase()` -> verified transaction -> entitlement unlock.
    func startFreeTrial() async {
        guard !isPurchasing else { return }
        isPurchasing = true
        try? await Task.sleep(for: .milliseconds(700)) // network/StoreKit round-trip
        isInTrial = true
        isSubscribed = true
        isPurchasing = false
    }

    /// Simulates StoreKit `AppStore.sync()` / RevenueCat `restorePurchases()`.
    func restorePurchases() async -> Bool {
        isPurchasing = true
        try? await Task.sleep(for: .milliseconds(500))
        isPurchasing = false
        // No prior purchase in this demo session unless a trial was started.
        return isSubscribed
    }

    func cancel() {
        isSubscribed = false
        isInTrial = false
    }

    /// Demo-driver override (used by -demo recording mode).
    func setSubscribed(_ value: Bool) { isSubscribed = value }
}
