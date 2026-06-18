---
name: Solaris Mobile
colors:
  surface: '#fdf9f3'
  surface-dim: '#dddad4'
  surface-bright: '#fdf9f3'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f7f3ed'
  surface-container: '#f1ede7'
  surface-container-high: '#ebe8e2'
  surface-container-highest: '#e6e2dc'
  on-surface: '#1c1c18'
  on-surface-variant: '#514532'
  inverse-surface: '#31302d'
  inverse-on-surface: '#f4f0ea'
  outline: '#837560'
  outline-variant: '#d5c4ab'
  surface-tint: '#7c5800'
  primary: '#7c5800'
  on-primary: '#ffffff'
  primary-container: '#ffb800'
  on-primary-container: '#6b4c00'
  inverse-primary: '#ffba20'
  secondary: '#a7391e'
  on-secondary: '#ffffff'
  secondary-container: '#fd7958'
  on-secondary-container: '#6e1500'
  tertiary: '#15686c'
  on-tertiary: '#ffffff'
  tertiary-container: '#89d1d5'
  on-tertiary-container: '#005b5f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdea8'
  primary-fixed-dim: '#ffba20'
  on-primary-fixed: '#271900'
  on-primary-fixed-variant: '#5e4200'
  secondary-fixed: '#ffdad2'
  secondary-fixed-dim: '#ffb4a2'
  on-secondary-fixed: '#3c0700'
  on-secondary-fixed-variant: '#862208'
  tertiary-fixed: '#a6eff3'
  tertiary-fixed-dim: '#8ad3d7'
  on-tertiary-fixed: '#002021'
  on-tertiary-fixed-variant: '#004f53'
  background: '#fdf9f3'
  on-background: '#1c1c18'
  surface-variant: '#e6e2dc'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 34px
    fontWeight: '800'
    lineHeight: 41px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 21px
  label-lg:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.05em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  callout:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 21px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  margin-mobile: 20px
  gutter-mobile: 16px
---

## Brand & Style
The brand personality is radiant, optimistic, and welcoming. This design system is crafted for a high-end mobile experience that feels like a breath of fresh air—warm, approachable, yet meticulously organized. It targets users who appreciate a "Premium Lifestyle" aesthetic: clean, breathable interfaces that evoke the feeling of a sun-drenched morning.

The style is a blend of **Modern Minimalism** and **Tactile Softness**. It utilizes generous whitespace to reduce cognitive load and emphasizes a "squishy" physical quality through large corner radii and soft, ambient depth. The UI should feel friendly and human, avoiding the sterile coldness of traditional enterprise apps.

## Colors
The palette is rooted in warmth. The primary "Sunny Yellow" (#FFB800) is used for highlights and positive reinforcements, while "Soft Orange" (#FF7A59) provides a gentle secondary accent for secondary actions or illustrations. 

For critical interactions and Call-to-Actions (CTAs), we employ a high-contrast **Deep Teal** (#005F63) to ensure visibility and accessibility against the warm background. The base of the application uses **Warm White** (#FFFBF5) for surfaces to create a softer visual experience than pure white, reducing eye strain and reinforcing the "sunny" brand narrative. Text is rendered in a deep charcoal (#2D2926) rather than pure black to maintain a sophisticated, organic feel.

## Typography
The typography system prioritizes clarity and a modern, "Apple-esque" polish. **Plus Jakarta Sans** is used for headlines to provide a friendly, slightly rounded geometric character that aligns with the brand's optimistic tone. **Inter** is utilized for body copy and labels to ensure maximum legibility at small sizes, maintaining a neutral but professional functional layer.

Hierarchy is driven by bold weights in headlines to create clear entry points for the eye. The `display` and `headline-lg` styles utilize tighter letter spacing to create a compact, premium editorial feel. All body text follows a comfortable 1.4x-1.5x line-height ratio to preserve the "breathable" nature of the design.

## Layout & Spacing
This design system follows a **Fluid iOS Grid** model. The layout is optimized for mobile-first interaction, using a standard 4-column or 2-column layout for content cards within a fluid container. 

The spacing rhythm is built on a **4px baseline grid**. For mobile, a standard **20px side margin** is enforced to give content plenty of room to breathe away from the device edges. Vertical spacing between sections should be generous (typically `xl` or `xxl` units) to emphasize the minimalist, premium feel. Content cards should be separated by `md` (16px) gutters.

## Elevation & Depth
Depth is created using **Ambient Shadows** and **Tonal Layering**. Instead of harsh, grey shadows, we use "Sun-kissed Shadows"—soft, diffused shadows with a subtle warm tint (e.g., #FFB800 at 5-10% opacity).

- **Level 0 (Base):** The main background (#FFFFFF).
- **Level 1 (Cards):** Surfaces in Warm White (#FFFBF5) with a very soft, wide-spread shadow (Y: 4, Blur: 20, Opacity: 0.05).
- **Level 2 (Active/Floating):** Higher elevation for floating action buttons or active states, utilizing a more pronounced shadow (Y: 8, Blur: 30, Opacity: 0.10).
- **Overlays:** Full-screen modals use a backdrop blur (20px) to maintain the "Glassmorphism" feel common in modern iOS patterns, keeping the user grounded in their previous context.

## Shapes
The shape language is defined by **High-Radius Enclosures**. Following the "Rounded" setting, standard components like buttons and small cards use a **16px** (1rem) radius. Large content cards and containers use **24px** (1.5rem) to create a soft, friendly silhouette.

Input fields and smaller UI elements like chips should maintain a minimum of 12px radius to ensure they never feel "sharp." This consistent roundness reinforces the approachable, tactile nature of the app.

## Components
- **Buttons:** 
  - *Primary:* Deep Teal (#005F63) background with White text. High-contrast for subscription triggers and main actions. Height: 56px for "thumb-friendly" accessibility.
  - *Secondary:* Warm White background with Sunny Yellow text or border.
- **Content Cards:** Uses the 24px radius. Cards should feature a 1px soft border in a slightly darker warm-grey to define edges without adding visual weight. 
- **Subscription Toggles:** Highly tactile, pill-shaped toggles. When active, they use a gradient of Soft Orange to Sunny Yellow to draw the eye.
- **Lists:** Inset grouped lists (standard iOS pattern) but with increased vertical padding (16px) per row to maintain the spacious aesthetic.
- **Inputs:** Backgrounds in a very faint grey-gold tint with no border; on focus, they transition to a Sunny Yellow subtle outer glow.
- **Chips/Badges:** Pill-shaped with the 32px radius. Use "Soft Orange" with 10% opacity backgrounds for a delicate, premium labeling system.