# CLAUDE.md - Pen to Prison

## Project Overview

**Pen to Prison** is a web platform designed to connect pen pals with incarcerated individuals, facilitating meaningful correspondence. The tagline is "Connecting Hearts Across Bars."

**Current status:** Early-stage frontend prototype. Only static HTML/CSS pages exist with no backend, database, or core business logic implemented.

## Repository Structure

```
pentoprison/
├── .github/
│   └── workflows/
│       └── main.yml          # CI/CD placeholder (empty - no pipeline configured)
├── index.html                 # Landing/home page (marketing, nav, testimonials, contact form)
├── register.html              # User registration page (client-side only, no backend)
├── styles.css                 # Global stylesheet
└── CLAUDE.md                  # This file
```

## Tech Stack

| Layer       | Technology                |
|-------------|---------------------------|
| Frontend    | HTML5, CSS3, Vanilla JS   |
| Backend     | None                      |
| Database    | None                      |
| Framework   | None                      |
| Build tools | None                      |
| Testing     | None                      |
| CI/CD       | GitHub Actions (empty)    |

No package manager, bundler, linter, formatter, or test runner is configured.

## Key Files

- **`index.html`** - Main landing page with four sections: header/nav, "How It Works" (3-step process), testimonials, and a contact form. References image assets (`step-1.png`, `step-2.png`, `step-3.png`, `user-avatar.png`) that do not exist in the repo.
- **`register.html`** - Registration form (username, email, password) with a vanilla JS submit handler. No backend integration; displays a success message client-side only.
- **`styles.css`** - Global styles. Primary color is `#4CAF50` (green). Uses flexbox for layout. No CSS framework.
- **`.github/workflows/main.yml`** - Empty file; no CI/CD pipeline defined.

## Development

### Running Locally

This is a static site. Open `index.html` directly in a browser or use any static file server:

```sh
python3 -m http.server 8000
# Then visit http://localhost:8000
```

### Build & Test Commands

There are no build steps, test commands, or scripts to run. No `package.json` or `Makefile` exists.

### Linting & Formatting

No linting or formatting tools are configured.

## Architecture Notes

- **Multi-page application (MPA):** Each page is a standalone HTML file. Navigation uses standard anchor links.
- **No templating or components:** All markup is inline HTML with no reuse mechanism.
- **No state management:** The registration form stores nothing persistently. Form submission is handled entirely client-side with `event.preventDefault()` and DOM manipulation.
- **No authentication/authorization:** The registration form collects credentials but does not transmit or store them anywhere.

## Design Conventions

- **Color scheme:** Green (`#4CAF50`) primary, white text on header, light gray (`#f1f1f1`) section backgrounds.
- **Layout:** Flexbox-based. Forms are centered with `max-width: 400px`.
- **Typography:** Arial/sans-serif, no web fonts loaded.
- **Button styling:** `.btn` class for CTA buttons (white background, green text); `button` element styled with green background and white text.

## What's Not Yet Implemented

The following core features are referenced or implied but have no implementation:

- Backend server and API
- Database and user persistence
- User authentication and session management
- Pen pal matching algorithm
- Letter/message exchange system
- Testimonial slider (commented as TODO)
- Contact form submission handling
- Image assets referenced in HTML
- CI/CD pipeline
- Deployment configuration
