# CRM Design System

> How the visual design system works, how to customise colours, and how to integrate
> with third-party UI kits / templates.

---

## How the Design System Works

The CRM uses **CSS custom properties (variables)** defined in `src/index.css` under
the `:root` (light mode) and `.dark` (dark mode) selectors. Every component
references these variables via `var(--color-*)`, `var(--bg-*)`, `var(--text-*)`, etc.

This means:

- **One source of truth** for every colour, background, and text tone.
- **Automatic dark mode** — flip `.dark` on `<html>` and every component updates.
- **Instant re-theming** — change a single variable to propagate the change
  across the entire app.

---

## Colour Slots Reference

| Variable              | Light      | Dark       | Used in                                    |
| --------------------- | ---------- | ---------- | ------------------------------------------ |
| `--color-primary`     | `#2563eb`  | `#2563eb`  | Buttons, links, active states, focus rings |
| `--color-primary-hover` | `#1d4ed8` | `#1d4ed8` | Button hover states                        |
| `--color-primary-light` | `#dbeafe` | —          | Alert backgrounds, active nav indicators   |
| `--color-secondary`   | `#64748b`  | `#64748b`  | Secondary text, muted UI                   |
| `--color-success`     | `#22c55e`  | `#22c55e`  | Success alerts, badges, status indicators  |
| `--color-warning`     | `#f59e0b`  | `#f59e0b`  | Warning alerts, pending states             |
| `--color-danger`      | `#ef4444`  | `#ef4444`  | Error alerts, destructive actions          |
| `--color-info`        | `#3b82f6`  | `#3b82f6`  | Info alerts, help indicators               |
| `--bg-primary`        | `#ffffff`  | `#0f172a`  | Cards, modals, page backgrounds            |
| `--bg-secondary`      | `#f8fafc`  | `#1e293b`  | Page background, table rows                |
| `--bg-tertiary`       | `#f1f5f9`  | `#334155`  | Hover states, subtle backgrounds           |
| `--text-primary`      | `#0f172a`  | `#f1f5f9`  | Headings, body text                        |
| `--text-secondary`    | `#475569`  | `#cbd5e1`  | Labels, secondary copy                    |
| `--text-muted`        | `#94a3b8`  | `#64748b`  | Placeholders, disabled text, hints         |
| `--border-color`      | `#e2e8f0`  | `#334155`  | Input borders, dividers, card borders      |
| `--sidebar-bg`        | `#1e293b`  | `#0f172a`  | Sidebar background                         |
| `--sidebar-text`      | `#cbd5e1`  | `#94a3b8`  | Sidebar text and icons                     |
| `--sidebar-hover`     | `#334155`  | `#1e293b`  | Sidebar item hover                         |
| `--sidebar-active`    | `#2563eb`  | `#2563eb`  | Sidebar active item indicator              |

---

## How to Define / Import a Custom Colour Palette

### Option 1 — Manual palette swap (most common)

You want to replace the default blue palette with, say, a **Saudi Green** theme.

**1. Collect your hex values** from your design spec (Figma, Adobe XD, etc.).

**2. Open `src/index.css` and replace the `:root` values**:

```css
:root {
  /* Brand colours */
  --color-primary: #1b5e20;          /* Deep green    */
  --color-primary-hover: #2e7d32;    /* Lighter green */
  --color-primary-light: #e8f5e9;    /* Very light    */
  --color-secondary: #546e7a;
  --color-success: #2e7d32;
  --color-warning: #f9a825;
  --color-danger: #c62828;
  --color-info: #1565c0;

  /* Backgrounds */
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --bg-tertiary: #eeeeee;

  /* Text */
  --text-primary: #212121;
  --text-secondary: #424242;
  --text-muted: #9e9e9e;

  /* Borders */
  --border-color: #e0e0e0;

  /* Sidebar */
  --sidebar-bg: #1b5e20;
  --sidebar-text: #c8e6c9;
  --sidebar-hover: #2e7d32;
  --sidebar-active: #388e3c;
}
```

**3. Update the `.dark` block** with dark-mode equivalents:

```css
.dark {
  --bg-primary: #1a1a2e;
  --bg-secondary: #16213e;
  --bg-tertiary: #0f3460;
  --text-primary: #e8f5e9;
  --text-secondary: #c8e6c9;
  --text-muted: #81c784;
  --border-color: #2e7d32;
  --sidebar-bg: #0d1b0e;
  --sidebar-text: #a5d6a7;
  --sidebar-hover: #1b5e20;
  --sidebar-active: #2e7d32;
}
```

**4. Done.** Every component that uses `var(--color-primary)` etc. will
automatically reflect the new palette.

---

### Option 2 — Importing from a purchased UI kit / template

Many premium templates (Tailwind Admin, Themesberg, etc.) ship with a
`tailwind.config.js` / `theme` object or a `:root` colour map.

1. **Locate the colour definitions** in the template — they're usually hex strings
   or Tailwind colour keys.
2. **Map each template colour to the CRM variable** using the table above.
3. **Copy the hex values** into `src/index.css` as shown in Option 1.
4. **Repeat for dark mode** if the template provides one.
5. **Test** by visiting every major page — the sidebar, buttons, forms, tables,
   and alerts should all match.

> If the template uses **Tailwind utility classes** (e.g. `bg-blue-500`), you
> will need to replace those with `bg-[var(--color-primary)]` or use Tailwind's
> `theme()` function if extended in `tailwind.config`.

---

### Option 3 — Adding a completely new colour slot

If you need a colour that doesn't have a variable yet (e.g. `--color-accent`):

1. **Add it to `:root`** in `src/index.css`:
   ```css
   :root {
     /* ... existing variables ... */
     --color-accent: #f97316; /* Orange accent */
   }
   ```
2. **Add a dark-mode override** in the `.dark` block:
   ```css
   .dark {
     /* ... existing overrides ... */
     --color-accent: #fb923c;
   }
   ```
3. **Use it in any component**:
   ```css
   .my-element {
     color: var(--color-accent);
   }
   ```
   Or in JSX with Tailwind:
   ```tsx
   <div className="text-[var(--color-accent)]">Accent text</div>
   ```

---

## Best Practices

| Rule | Why |
| ---- | --- |
| **Never hardcode hex values** in components | Hardcoding breaks dark mode and makes re-theming a nightmare. Always use `var(--color-*)` or `var(--bg-*)`. |
| **Always provide a dark mode override** for every new variable | Otherwise the dark theme will look broken with orphan light colours. |
| **Use `color-mix()` for alpha/transparency** | e.g. `color-mix(in srgb, var(--color-primary) 10%, transparent)` instead of `rgba(var(--color-primary-rgb), 0.1)`. This avoids needing separate `--*-rgb` variables. |
| **Add new variables to this README** | Keep the reference table up to date so other developers know what's available. |
| **Prefer CSS variables over Tailwind `theme()`** | CSS variables are dynamic and can be changed at runtime (e.g. for theme toggling). Tailwind's `theme()` is compile-time only. |

---

## Using CSS Variables with Tailwind v4

In Tailwind v4, custom CSS variables can be used directly in utility classes:

```tsx
<button className="bg-[var(--color-primary)] text-white rounded-lg px-4 py-2">
  Click me
</button>
```

For complex values (shadows, gradients) you can also reference them in your
`index.css` custom layer:

```css
@layer base {
  .shadow-card {
    box-shadow: 0 4px 24px color-mix(in srgb, var(--color-primary) 10%, transparent);
  }
}
```

---

## File Location

```
src/
├── index.css          ← All CSS variables for light + dark mode
├── design/
│   └── README.md      ← This file
└── ... (components, features, etc.)
```
