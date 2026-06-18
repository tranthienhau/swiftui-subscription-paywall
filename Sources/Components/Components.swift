import SwiftUI

/// Deep-teal high-contrast CTA used for subscription + primary actions. 56pt, thumb-friendly.
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = "arrow.right"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Space.xs) {
                Text(title).font(.callout.weight(.bold))
                if let systemImage { Image(systemName: systemImage) }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Theme.Palette.tertiary, in: .rect(cornerRadius: Theme.Radius.button))
        }
        .buttonStyle(.plain)
    }
}

/// Pill filter chip (Featured / New Releases / categories).
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.labelLg)
                .foregroundStyle(isSelected ? .white : Theme.Palette.onSurfaceVariant)
                .padding(.horizontal, Theme.Space.md)
                .padding(.vertical, 10)
                .background(
                    isSelected ? Theme.Palette.primary : Theme.Palette.surfaceContainerHigh,
                    in: .capsule
                )
        }
        .buttonStyle(.plain)
    }
}

/// Soft-orange tinted pill badge (category labels).
struct TagBadge: View {
    let text: String
    var tint: Color = Theme.Palette.secondaryContainer

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .bold))
            .tracking(0.5)
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(tint.opacity(0.14), in: .capsule)
    }
}

/// Gradient artwork stand-in for content thumbnails (keeps the POC self-contained,
/// no bundled photo assets). Seeded per-item so cards look distinct + stable.
struct Artwork: View {
    let seed: Int
    var icon: String = "photo"

    private var colors: [Color] {
        let palettes: [[Color]] = [
            [Theme.Palette.gradientStart, Theme.Palette.gradientEnd],
            [Theme.Palette.tertiaryContainer, Theme.Palette.tertiary],
            [Theme.Palette.primaryContainer, Theme.Palette.secondary],
            [Theme.Palette.secondaryContainer, Theme.Palette.primary],
        ]
        return palettes[abs(seed) % palettes.count]
    }

    var body: some View {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
            )
    }
}

/// Lock glyph badge for premium-gated content.
struct LockBadge: View {
    var body: some View {
        Image(systemName: "lock.fill")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(Theme.Palette.primary)
            .padding(7)
            .background(.white.opacity(0.92), in: .circle)
    }
}
