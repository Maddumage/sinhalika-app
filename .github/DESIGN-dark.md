# Design System Specification: Dark Mode Editorial

## 1. Overview & Creative North Star: "The Midnight Playground"
The Creative North Star for this design system is **"The Midnight Playground."** It is an intentional departure from the sterile, flat dark modes typical of productivity apps. Instead, it embraces a high-end, editorial aesthetic that feels both premium and approachable. 

The system breaks the traditional "template" look by utilizing **intentional asymmetry** and **tonal depth**. Rather than rigid grids, we use overlapping elements and varied surface elevations to create a sense of discovery. It is "child-friendly" not through clutter, but through extreme roundness and vibrant, glowing accents that pop against a sophisticated charcoal abyss.

---

## 2. Colors & Surface Architecture
The color palette transitions from the "vibrant" light mode into a "neon-noir" aesthetic. Accents are slightly desaturated to prevent eye strain while maintaining their playful energy.

### Color Tokens
- **Background:** `#0c0e11` (Deep Slate)
- **Primary (Electric Blue):** `#6cb2fd` (A desaturated, luminous blue for high legibility)
- **Secondary (Glowing Amber):** `#ff9800` (The core "warmth" of the system)
- **Tertiary (Neon Coral):** `#ff7161` (A softened version of the original red for error and high-alert states)

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders to section off content. Boundaries must be defined solely through:
1.  **Background Color Shifts:** Use `surface-container-low` for secondary sections sitting on a `surface` background.
2.  **Tonal Transitions:** Use vertical white space (`spacing-12` or `spacing-16`) to create mental breaks without visual "fences."

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following container tiers to create "nested" depth:
- **Surface (Base):** `#0c0e11` - The foundation.
- **Surface Container Low:** `#111417` - For large structural areas (e.g., sidebars).
- **Surface Container High:** `#1d2024` - For primary interactive cards.
- **Surface Container Highest:** `#23262a` - For modals and "floating" elements.

### The "Glass & Gradient" Rule
To move beyond a "standard" dark mode, use **Glassmorphism** for floating elements (Top Nav, Floating Action Buttons). Apply `surface-container-highest` at 70% opacity with a `backdrop-blur` of 20px. 
**Signature Texture:** Use a subtle linear gradient (Top-Left to Bottom-Right) transitioning from `primary` to `primary-container` for Hero CTAs to give them a "pulsing" soul.

---

## 3. Typography: The Editorial Voice
We use **Plus Jakarta Sans** exclusively. Its geometric nature provides the "friendly" feel, while our scale provides the "authority."

- **Display (lg/md/sm):** 3.5rem to 2.25rem. Used for hero moments. Use `-0.02em` letter spacing to make it feel tight and custom.
- **Headline (lg/md/sm):** 2rem to 1.5rem. These should be "SemiBold" to anchor the page.
- **Title (lg/md/sm):** 1.375rem to 1rem. Used for card headers.
- **Body (lg/md):** 1rem to 0.875rem. Always use `on-surface-variant` (`#aaabaf`) for long-form body text to reduce contrast-induced fatigue.
- **Label:** 0.75rem. Use for small utility text, always in "Medium" weight.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows and borders are replaced by **Layering Principles.**

- **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. The subtle shift in hex code creates a soft, natural lift.
- **Ambient Shadows:** For floating modals, use a shadow with a 40px blur and 8% opacity. The shadow color must be the `on-surface` color (`#f9f9fd`) tinted, creating a "light-leak" effect rather than a black void.
- **The Ghost Border Fallback:** If a border is required for accessibility, use the `outline-variant` (`#46484b`) at **15% opacity**. Never use 100% opaque borders.

---

## 5. Components

### Buttons
- **Primary:** Full roundness (`9999px`). Background: `primary` gradient. Text: `on-primary` (`#003055`).
- **Secondary:** Full roundness. Surface: `surface-container-highest`. Animate a slight "glow" on hover using a `primary` drop-shadow at 20% opacity.
- **Tertiary:** No background. Text: `primary`. High-end editorial look.

### Input Fields
Avoid the "box" look. Use a `surface-container-high` background with a `full` roundness scale. The label should sit 0.5rem above the input in `label-md`.

### Cards & Lists
**Forbid divider lines.** Separate list items using `spacing-4` (1rem) of vertical gap. To distinguish a card from the background, rely on the shift from `surface` to `surface-container-high`.

### The "Play" Chip
A custom component for this system. Use `secondary` (`#ff9800`) with a desaturated neon glow (`box-shadow: 0 0 15px #ff980033`) to highlight active status or playful categories.

---

## 6. Do’s and Don’ts

### Do:
- **Use Intentional Asymmetry:** Align a headline to the left but offset the body text to the right using `spacing-10` to create an editorial feel.
- **Embrace Negative Space:** If you think you have enough padding, add `spacing-4` more. 
- **Use Soft Neon:** Apply a subtle glow to icons using the `primary` color at low opacities.

### Don't:
- **Don't use 1px lines:** Do not use lines to separate header from body or sidebar from content.
- **Don't use pure white:** Never use `#ffffff` for text. Use `on-surface` (`#f9f9fd`) to keep the "Midnight" vibe.
- **Don't use sharp corners:** Every interactive element must use at least `rounded-md` (1.5rem) or `full` roundness. Sharp corners are "hostile" in this system.