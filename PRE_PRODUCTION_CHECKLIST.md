# Pre-Production Checklist

> Check off each item before deploying to production.

---

## 1. Environment Variables

### Backend (`backend/.env`)

- [ ] `APP_ENV=production` — change from `local`
- [ ] `APP_DEBUG=false` — never show stack traces in production
- [ ] `APP_URL` — set to the production domain
- [ ] `APP_KEY` — must be unique per environment; generate with `php artisan key:generate` if deploying fresh
- [ ] `DB_PASSWORD` — use a strong, production-only password (not the dev password)
- [ ] `REDIS_PASSWORD` — use a strong, production-only password
- [ ] `SENTRY_LARAVEL_DSN` — replace the placeholder with your real Sentry project DSN
- [ ] `SENTRY_TRACES_SAMPLE_RATE=0.25` — enable performance tracing in production
- [ ] `SENTRY_ENVIRONMENT=production`
- [ ] `SENTRY_RELEASE` — set to the git commit hash or release tag
- [ ] `LOG_LEVEL=warning` — reduce log verbosity (was `debug`)
- [ ] `MAIL_MAILER` — configure real mail driver (`smtp`, `ses`, etc.), not `log`

### CRM (`crm/.env`)

- [ ] `VITE_SENTRY_DSN` — replace the placeholder with your real Sentry project DSN
- [ ] `VITE_SENTRY_ENVIRONMENT=production`
- [ ] `VITE_SENTRY_TRACES_SAMPLE_RATE=0.25` — enable performance tracing in production
- [ ] `VITE_API_URL` — set to the production API URL (e.g., `https://api.example.com/api/v1`)

### Mobile Apps

- [ ] `customer-app/` — set `SENTRY_DSN` via `--dart-define=SENTRY_DSN=...` in build command
- [ ] `driver-app/` — set `SENTRY_DSN` via `--dart-define=SENTRY_DSN=...` in build command
- [ ] `customer-app/` — set `API_BASE_URL` via `--dart-define=API_BASE_URL=...` in build command
- [ ] `driver-app/` — set `API_BASE_URL` via `--dart-define=API_BASE_URL=...` in build command

---

## 2. Sentry & Error Tracking

- [ ] Backend: `SENTRY_LARAVEL_DSN` set to real DSN (backend `.env`)
- [ ] Backend: Verify Sentry reports with `php artisan sentry:test`
- [ ] CRM: `VITE_SENTRY_DSN` set to real DSN (`crm/.env`)
- [ ] CRM: Verify Sentry initialises in browser console (no errors)
- [ ] Mobile: `SENTRY_DSN` passed via `--dart-define` in both apps' build commands
- [ ] Mobile: Verify Sentry init log in `adb logcat` or Xcode console

---

## 3. Queue & Horizon

- [ ] Redis server is running and accessible
- [ ] `php artisan horizon` is running as a daemon (systemd/supervisor process)
- [ ] Horizon dashboard accessible at `/horizon` and gate‑protected

---

## 4. Database

- [ ] Run all pending migrations: `php artisan migrate --force`
- [ ] Run seeders if needed: `php artisan db:seed --force`
- [ ] Verify `DB_SOCKET` or `DB_HOST`/`DB_PORT` matches the production MySQL setup
- [ ] Set up automated database backups

---

## 5. Build & Deploy

### Backend
- [ ] `composer install --no-dev --optimize-autoloader`
- [ ] `php artisan config:cache`
- [ ] `php artisan route:cache`
- [ ] `php artisan view:cache`
- [ ] `php artisan event:cache`
- [ ] `php artisan storage:link` (if using local file storage)

### CRM
- [ ] `npm ci && npm run build` — production build
- [ ] Verify `dist/` is served by the web server
- [ ] Verify all API routes proxy correctly to the backend

---

## 6. Security

- [ ] CORS configured for the CRM domain in `backend/config/cors.php`
- [ ] Sanctum stateful domains configured in `backend/config/sanctum.php`
- [ ] HTTPS enforced on all endpoints
- [ ] `APP_DEBUG=false` confirmed
- [ ] Default credentials changed (super admin email/password)
- [ ] File upload validation in place (size, type, scan)

---

## 7. Monitoring

- [ ] Sentry alerts configured for new errors
- [ ] Horizon metrics dashboard set up (failed jobs, throughput)
- [ ] Redis cache hit/miss ratio healthy
- [ ] Queue worker processes monitored (restart on failure)

---

## 8. Final Verification

- [ ] `php artisan test` — all tests pass
- [ ] `npm run lint` — CRM lint clean
- [ ] `flutter test` — mobile tests pass (both apps)
- [ ] Smoke test: register a user → create a booking → complete the flow
- [ ] Smoke test: driver login → accept job → complete
- [ ] Smoke test: admin CRM login → manage users → view reports
- [ ] RTL/LTR switch works in CRM and both mobile apps
- [ ] Dark mode toggle works in CRM
