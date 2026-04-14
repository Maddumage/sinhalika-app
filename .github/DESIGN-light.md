```markdown
# Design System Documentation: The Heritage Playroom

## 1. Overview & Creative North Star
**Creative North Star: "The Modern Lotus"**

This design system rejects the "sterile classroom" aesthetic in favor of a vibrant, high-end editorial experience for children. We are moving beyond standard educational apps by blending **Organic Geometricism** with **Modernized Heritage**. 

The goal is to make the Sinhala script feel like an art form. We break the template look by using **intentional asymmetry**—imagine a layout that feels like a beautifully curated scrapbook rather than a rigid spreadsheet. We utilize overlapping elements (e.g., a character illustration breaking the boundary of a container) and high-contrast typography scales to create a sense of wonder and hierarchy.

---

## 2. Colors: Tonal Vibrancy
The palette is a tribute to Sri Lankan landscapes and traditional textiles, balanced by a sophisticated "Off-White" parchment base.

### The Palette
- **Primary (`#c41f19`) & Primary Container (`#ff7767`):** Inspired by traditional lacquerware. Use for "Eureka" moments and primary calls to action.
- **Secondary (`#0067ad`) & Secondary Container (`#b3d4ff`):** Represents the Indian Ocean. Use for navigation and interactive discovery elements.
- **Tertiary (`#00751f`) & Tertiary Container (`#91f78e`):** The lush tea hills. Use for progress tracking and success states.
- **Background (`#fefcf4`):** A warm, eye-friendly surface that prioritizes the readability of the intricate Sinhala glyphs.

### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders to section content. Boundaries must be defined through background color shifts. For example, a `surface-container-low` card sitting on a `surface` background provides all the definition a child needs without the visual "noise" of a stroke.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. 
- **Base:** `surface`
- **Level 1 (Sections):** `surface-container-low`
- **Level 2 (Interactive Cards):** `surface-container-lowest` (to make them "pop" as the brightest element).
- **Level 3 (Overlays):** Use `surface-variant` with a 10% opacity for subtle depth.

### Signature Textures & Glass
To provide a "High-End" feel, use **Glassmorphism** for floating navigation bars or celebratory modals. Use `surface-bright` at 70% opacity with a `backdrop-blur` of 20px. 

---

## 3. Typography: Script as Hero
Sinhala script is round and rhythmic. Our typography choices must complement, not compete with, these forms.

- **Display & Headlines (Plus Jakarta Sans):** A modern, friendly sans-serif with high legibility. Use `display-lg` (3.5rem) for big "Alphabet Wins" and `headline-md` (1.75rem) for module titles. The wide apertures of Jakarta Sans mirror the circular nature of Sinhala characters.
- **Body & Labels (Be Vietnam Pro):** A clean, professional face that provides a neutral counterpoint to the decorative headlines. 
- **Hierarchy Logic:** Use `primary` color for `headline-sm` to draw the eye to instructions. Use `on-surface-variant` for `body-sm` to de-emphasize meta-information.

---

## 4. Elevation & Depth: Tonal Layering
We achieve depth through "Soft Stack" logic rather than harsh shadows.

- **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container` background. This creates a soft, natural "lift."
- **Ambient Shadows:** For floating elements (like a "Speak" button), use a shadow with a blur of `32px`, offset `y: 8px`, and an opacity of 6% using a tinted version of `on-surface`. Never use pure black shadows.
- **The "Ghost Border" Fallback:** If a container needs more definition (e.g., in high-glare environments), use the `outline-variant` token at **15% opacity**.
- **The "Heritage Cut":** Use the `xl` (3rem) or `full` (9999px) roundedness for large containers to mimic the soft curves of traditional moonstones (*Sandakada Pahana*).

---

## 5. Components

### Buttons
- **Primary:** Use a gradient from `primary` to `primary-fixed-dim`. Shape: `full`. Padding: `spacing-4` (1.4rem) horizontal.
- **Secondary:** `surface-container-highest` background with `secondary` text. No border.

### Chips (Learning Tags)
- Use `tertiary-container` for completed lessons and `secondary-container` for active ones. 
- **Rule:** Forbid 1px borders; use a subtle `0.5rem` (sm) corner radius.

### Input Fields (Sinhala Writing Pads)
- Use `surface-container-lowest` as the background. 
- On focus, transition the background to `surface-bright` and add a `ghost border` using `primary` at 20% opacity.

### Educational Cards
- **Forbid dividers.** Use `spacing-6` (2rem) of vertical white space to separate the Sinhala character from its phonetic English translation.
- **The "Art Break":** Allow illustrations to bleed off the edge of the card, using the `lg` (2rem) corner radius to clip the image.

### Progress Trackers
- Avoid thin lines. Use thick, `full` rounded tracks using `surface-container-highest` with a `tertiary` fill to represent growth.

---

## 6. Do’s and Don’ts

### Do:
- **Prioritize the Script:** Ensure `display` sizes for Sinhala characters are at least 20% larger than the surrounding English text to account for complex modifiers (*pili*).
- **Embrace Asymmetry:** Place a decorative element (like a stylized lotus petal) slightly off-center to break the "grid-lock."
- **Use Color as Wayfinding:** Use `secondary` consistently for "Next/Forward" and `primary` for "Home/Back."

### Don't:
- **Don't use 1px lines:** They feel "cheap" and clinical. Use color blocks instead.
- **Don't use harsh shadows:** Children's interfaces should feel airy and light, not heavy and "3D-rendered."
- **Don't crowd the script:** Sinhala needs "breathing room" (use `spacing-4` minimum padding) to prevent the modifiers from looking like visual clutter.
- **Don't use pure black (`#000000`):** Use `on-surface` (`#383833`) for all text to maintain the premium, editorial feel.