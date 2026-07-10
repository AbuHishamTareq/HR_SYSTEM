# AGENTS.md — hr-system

Human Resources & Home Services Management Platform — a monorepo containing a
Laravel 13 API, a React 19 CRM web app, and two Flutter mobile apps (customer + driver).

## Structure

```
.opencode/          — OpenCode agent definitions (do not touch)
.opencode/plans/    — Task tracking files (TASKS.md)
backend/            — Laravel 13 RESTful API (PHP 8.4, MySQL 8, Redis)
crm/                — React 19 CRM web portal (Vite, TypeScript, Tailwind)
customer-app/       — Flutter customer mobile app (Riverpod, Dio, GoRouter)
driver-app/         — Flutter driver mobile app (Riverpod, Dio, GoRouter)
TASKS.md            — 145-task breakdown across 6 phases
```

## What matters

- Application source code lives in `backend/`, `crm/`, `customer-app/`, `driver-app/`.
- `.opencode/` is the agent definitions collection — never touch `package.json` or `node_modules/` in it.
- Progress is tracked in `.opencode/plans/TASKS.md` — mark `[ ]` → `[X]` as tasks complete.

## Backend commands (Laravel 13)

```bash
composer install                        # Install PHP dependencies
php artisan migrate                     # Run database migrations
php artisan db:seed                     # Seed roles, permissions, base data
php artisan serve                       # Dev server on localhost:8000
php artisan queue:work                  # Process queued jobs
php artisan horizon                     # Horizon dashboard for queues
php artisan test                        # Run Pest test suite
./vendor/bin/pint                       # Laravel Pint (PSR-12 lint fix)
```

## CRM commands (React 19 + Vite)

```bash
npm install                             # Install JS dependencies
npm run dev                             # Vite dev server
npm run build                           # Production build
npm run lint                            # ESLint + TypeScript check
```

## Flutter commands (both apps)

```bash
flutter pub get                         # Install Dart dependencies
flutter run                             # Run on connected device/emulator
flutter test                            # Run widget/unit tests
flutter build apk                       # Android APK build
flutter build ios                       # iOS archive build
```

## Architecture notes

- **API versioning**: URI-based (`/api/v1/...`). New versions are isolated directories.
- **Auth**: Sanctum tokens for mobile; Sanctum SPA cookies for CRM.
- **Testing**: Pest (backend), React Testing Library (CRM), flutter_test (mobile).
- **RTL**: CSS `dir` attribute in CRM; Flutter `Directionality` widget in mobile.
- **Payments**: Moyasar (primary) via Flutter SDK; abstracted gateway interface.
- **SMS**: Abstracted `SmsProvider` interface — provider TBD.
- **Queue + Cache**: Redis via Horizon.
- **Theme**: Light-first with CSS-variable-based dark mode toggle.

## Work conventions

- Run `pint` before committing backend changes.
- Run `npm run lint` before committing CRM changes.
- Run `php artisan test` before opening a backend PR.
- New features require: migration → model → service → repository → controller → request → resource → route → test.
- Update `.opencode/plans/TASKS.md` as tasks are completed.
