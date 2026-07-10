# Tasks — HR & Home Services Management Platform

**Legend:** `[ ]` = pending, `[X]` = completed, `[-]` = in progress

---

## Phase 1 — Foundation (Weeks 1-3)

### Sprint 1.1: Backend Scaffold
- [X] 1.1.1 Create Laravel 13 project in `backend/` with PHP 8.4
- [X] 1.1.2 Configure Sanctum auth, JSON:API resources, Scramble docs
- [X] 1.1.3 Set up strict directory structure (Actions, DTOs, Repositories, Services)
- [X] 1.1.4 Configure MySQL 8, Redis, queue drivers
- [X] 1.1.4a Install & configure Laravel Horizon (Redis queue, supervisor config, Spatie gate)
- [X] 1.1.4b Install & configure Sentry error tracking (DSN, tracing, environment-aware)
- [X] 1.1.5 Configure Pest testing suite with CI-ready setup
- [X] 1.1.6 Create base API response trait, exception handler, rate limiting middleware
- [X] 1.1.7 Create `User` migration, model, repository, service, controller
- [X] 1.1.8 Implement Sanctum token auth endpoints (register, login, logout, me)
- [X] 1.1.9 Implement RBAC: `roles`, `permissions` migrations + seeders
- [X] 1.1.10 Build user management API (CRUD with role-based authorization)
- [X] 1.1.11 Set up `Settings` module (key-value config, cached in Redis)
- [X] 1.1.12 Implement API versioning scaffold (`routes/api/v1.php`)

### Sprint 1.2: CRM Scaffold (React 19)
- [X] 1.2.1 Initialize Vite + React 19 + TypeScript project in `crm/`
- [X] 1.2.2 Configure Tailwind CSS v4, PostCSS, CSS variables for theming
- [X] 1.2.3 Set up React Router v7 with layout routes
- [X] 1.2.4 Set up TanStack Query with Axios instance and interceptors
- [X] 1.2.5 Set up Zustand stores (auth, theme, locale, sidebar)
- [X] 1.2.6 Configure i18next with AR/EN namespaces and RTL `dir` switching
- [X] 1.2.7 Build Login page (email/password) with Zod + React Hook Form
- [X] 1.2.8 Build auth guard, protected layout with sidebar + header
- [X] 1.2.9 Implement dark mode toggle (localStorage-persisted Zustand)
- [X] 1.2.10 Create shared UI component library (Button, Input, Modal, Table, Card, Badge)

### Sprint 1.3: Flutter Scaffolds
- [X] 1.3.1 Initialize `customer-app/` Flutter project with latest stable
- [X] 1.3.2 Set up Riverpod 3.x with providers structure
- [X] 1.3.3 Set up GoRouter with ShellRoute for bottom navigation
- [X] 1.3.4 Set up Dio client with auth token interceptor
- [X] 1.3.5 Configure `flutter_localizations` for AR/EN + RTL Directionality
- [X] 1.3.6 Build light/dark theme system with `ThemeData.brightness`
- [X] 1.3.7 Implement SplashScreen + OnboardingScreen (3 slides, shown once)
- [X] 1.3.8 Implement login screen (phone input) + OTP screen with timer
- [X] 1.3.9 Create shared widget library (AppButton, AppTextField, AppCard, etc.)
- [X] 1.3.10 Repeat steps 1.3.1–1.3.4 for `driver-app/`
- [X] 1.3.11 Implement driver login screen (username + password)
- [X] 1.3.12 Build driver main scaffold with bottom nav (Dashboard, History, Profile)

---

## Phase 2 — Core Booking (Weeks 4-7)

### Sprint 2.1: Services & Categories
- [ ] 2.1.1 Create `service_categories` migration, model, repository, service, controller
- [ ] 2.1.2 Create `services` migration, model, repository, service, controller
- [ ] 2.1.3 Build service category CRUD in CRM (list, create, edit, delete)
- [ ] 2.1.4 Build service CRUD in CRM (list, create, edit, delete, media upload)
- [ ] 2.1.5 Build Browse Services + Categories screens in customer app

### Sprint 2.2: Customers & Workers
- [ ] 2.2.1 Create `customers` migration and full CRUD API
- [ ] 2.2.2 Create `addresses` migration with lat/lng, label, is_default
- [ ] 2.2.3 Build customer management UI in CRM
- [ ] 2.2.4 Create `workers` migration (name, phone, photo, status, skills JSON)
- [ ] 2.2.5 Create `worker_skills` pivot table
- [ ] 2.2.6 Build worker management UI in CRM (create, edit, assign skills, documents)

### Sprint 2.3: Booking Engine
- [ ] 2.3.1 Create `bookings` migration with status state machine
- [ ] 2.3.2 Create `booking_workers` pivot (worker assignment to bookings)
- [ ] 2.3.3 Create `BookingService` with state transitions (enum-backed)
- [ ] 2.3.4 Implement booking API endpoints (create, list, show, cancel, status update)
- [ ] 2.3.5 Build booking creation form in CRM (select customer, service, date, time, worker type, worker count)
- [ ] 2.3.6 Build booking list + detail view in CRM
- [ ] 2.3.7 Build booking flow in customer app (select service → date/time → worker config → summary → confirm)
- [ ] 2.3.8 Build Orders list + Order detail screens in customer app

### Sprint 2.4: Driver Setup
- [ ] 2.4.1 Create `drivers` migration (username, password, phone, status, vehicle info)
- [ ] 2.4.2 Create `driver_locations` table (lat, lng, timestamp, driver_id)
- [ ] 2.4.3 Build driver CRUD in CRM (create, edit, activate/deactivate)
- [ ] 2.4.4 Implement driver auth API (username/password → Sanctum token)
- [ ] 2.4.5 Build driver dashboard screen (assigned jobs list)

---

## Phase 3 — Dispatch, Maps & Live Tracking (Weeks 8-10)

### Sprint 3.1: Dispatch
- [ ] 3.1.1 Create `dispatches` migration (booking_id, driver_id, status, assigned_at, accepted_at)
- [ ] 3.1.2 Create `dispatch_logs` migration (dispatch_id, action, timestamp)
- [ ] 3.1.3 Implement manual dispatch API (assign driver to booking)
- [ ] 3.1.4 Build dispatch UI in CRM (booking detail → select driver → dispatch)
- [ ] 3.1.5 Implement driver accept/reject job flow API
- [ ] 3.1.6 Build driver job accept/reject UI in driver app

### Sprint 3.2: Maps Integration
- [ ] 3.2.1 Set up Google Maps API keys and service configs for all platforms
- [ ] 3.2.2 Implement backend geocoding service (Google Geocoding API)
- [ ] 3.2.3 Integrate Google Maps Flutter plugin in customer app
- [ ] 3.2.4 Build location picker screen (current location, search, pin, saved addresses)
- [ ] 3.2.5 Integrate Google Maps Flutter plugin in driver app
- [ ] 3.2.6 Integrate Google Maps React component in CRM

### Sprint 3.3: Live Tracking
- [ ] 3.3.1 Implement driver GPS location update endpoint (every 10s)
- [ ] 3.3.2 Implement customer booking tracking endpoint (returns driver location)
- [ ] 3.3.3 Build live driver → customer navigation flow in driver app
- [ ] 3.3.4 Build live customer tracking view in customer app (map with driver marker)
- [ ] 3.3.5 Build CRM map view (overlay drivers, workers, coverage zones)

### Sprint 3.4: Driver Workflow State Machine
- [ ] 3.4.1 Implement full state transition API for driver workflow (9 steps)
- [ ] 3.4.2 Build driver workflow screens: WorkerPickup → CustomerDropoff → ServiceTimer → WorkerPickupReturn → Complete
- [ ] 3.4.3 Implement 30-minute-before-completion notification trigger
- [ ] 3.4.4 Implement booking timeline endpoint (returns all status transitions)
- [ ] 3.4.5 Build booking timeline UI in driver app and customer app

---

## Phase 4 — Payments & Wallet (Weeks 11-12)

### Sprint 4.1: Wallet
- [ ] 4.1.1 Create `wallets` migration (customer_id, balance)
- [ ] 4.1.2 Create `wallet_transactions` migration (type, amount, reference_type, reference_id, description)
- [ ] 4.1.3 Implement wallet API (balance, history, recharge)
- [ ] 4.1.4 Build wallet UI in customer app (balance, history, recharge button)
- [ ] 4.1.5 Implement wallet refund logic

### Sprint 4.2: Payment Engine
- [ ] 4.2.1 Create `payments` migration (booking_id, amount, gateway, gateway_ref, status)
- [ ] 4.2.2 Create `refunds` migration (payment_id, amount, reason, status)
- [ ] 4.2.3 Create abstract `PaymentGateway` interface
- [ ] 4.2.4 Implement Moyasar payment gateway integration (backend)
- [ ] 4.2.5 Build payment intent API (create payment, check status)
- [ ] 4.2.6 Implement payment after service completion flow

### Sprint 4.3: Payment UX
- [ ] 4.3.1 Integrate Moyasar Flutter SDK in customer app
- [ ] 4.3.2 Build payment screen (Moyasar checkout, success, failure screens)
- [ ] 4.3.3 Build payment history screen in customer app
- [ ] 4.3.4 Build CRM: payment list, detail, manual refund
- [ ] 4.3.5 Implement CRM "send payment link" flow (booking → payment link → customer pays)

---

## Phase 5 — Notifications, HR & Accounting (Weeks 13-15)

### Sprint 5.1: Notifications
- [ ] 5.1.1 Create `notification_templates` migration (type, title_ar, title_en, body_ar, body_en, channels)
- [ ] 5.1.2 Integrate Firebase Cloud Messaging (backend + both mobile apps)
- [ ] 5.1.3 Create `NotificationService` (dispatch push, database, email)
- [ ] 5.1.4 Implement notification event/listener pairs for all booking/payment/wallet events
- [ ] 5.1.5 Build notification management UI in CRM (templates, triggers)
- [ ] 5.1.6 Build notifications list screen in customer app
- [ ] 5.1.7 Build notifications list screen in driver app

### Sprint 5.2: Coupons & Promotions
- [ ] 5.2.1 Create `coupons` migration with all fields (code, type, value, dates, usage limits, customer restrictions)
- [ ] 5.2.2 Create `coupon_usages` migration
- [ ] 5.2.3 Implement coupon validation + application logic in `BookingService`
- [ ] 5.2.4 Build coupon management UI in CRM (CRUD with all constraints)
- [ ] 5.2.5 Create `promotions` migration (title, description, image, period, type)
- [ ] 5.2.6 Create `campaigns` and `banners` migrations
- [ ] 5.2.7 Build promotions management UI in CRM (create campaign, upload banners)
- [ ] 5.2.8 Build Offers + Coupon entry screens in customer app

### Sprint 5.3: HR Module
- [ ] 5.3.1 Create `employees` migration (full HR profile)
- [ ] 5.3.2 Create `contracts` migration (type, start/end date, documents, status)
- [ ] 5.3.3 Create `documents` polymorphic table (passports, IDs, CVs, certificates)
- [ ] 5.3.4 Create `attendance` migration (date, check_in, check_out, status)
- [ ] 5.3.5 Create `leaves` migration (type, dates, reason, status)
- [ ] 5.3.6 Create `performance_reviews` migration
- [ ] 5.3.7 Build HR management UI in CRM (employees, workers, drivers, contracts, docs, attendance, vacations)

### Sprint 5.4: Accounting
- [ ] 5.4.1 Create `revenues` and `expenses` migrations
- [ ] 5.4.2 Implement accounting aggregation service (wallet, payments, fees)
- [ ] 5.4.3 Build accounting dashboard in CRM (revenues, expenses, wallet tx, payments, refunds)
- [ ] 5.4.4 Build financial reports with filters (date range, type, payment method)

---

## Phase 6 — Reports, Polish & Deployment (Weeks 16-18)

### Sprint 6.1: Reports
- [ ] 6.1.1 Implement report generators (Orders, Revenue, Workers, Drivers, Customers, Services, Wallet, Coupons, Promotions)
- [ ] 6.1.2 Integrate PDF export (barryvdh/laravel-dompdf or similar)
- [ ] 6.1.3 Integrate Excel export (Laravel Excel / PhpSpreadsheet)
- [ ] 6.1.4 Build reports UI in CRM with filters and export buttons

### Sprint 6.2: Audit & Security
- [ ] 6.2.1 Create `audit_logs` migration (user_id, action, entity_type, entity_id, old_values, new_values, ip, user_agent)
- [ ] 6.2.2 Implement Audit middleware + model event listeners
- [ ] 6.2.3 Create `activity_logs` migration (user_id, description, type)
- [ ] 6.2.4 Implement rate limiting, input validation hardening, file upload security
- [ ] 6.2.5 Build audit log viewer UI in CRM (filters by user, action, date)

### Sprint 6.3: Polish
- [ ] 6.3.1 Complete missing translations (AR/EN) across CRM and both mobile apps
- [ ] 6.3.2 Responsive QA on CRM (tablet, mobile breakpoints)
- [ ] 6.3.3 RTL visual QA across all three platforms
- [ ] 6.3.4 Dark mode visual QA
- [ ] 6.3.5 Error state + empty state + loading state screens across all platforms

### Sprint 6.4: Testing
- [ ] 6.4.1 Write Pest feature tests for all booking state transitions
- [ ] 6.4.2 Write Pest tests for payment and wallet flows
- [ ] 6.4.3 Write Pest tests for RBAC (role/permission enforcement)
- [ ] 6.4.4 Write Pest tests for coupon validation logic
- [ ] 6.4.5 Write React Testing Library tests for CRM (critical paths: login, booking create, dispatch)
- [ ] 6.4.6 Write Flutter widget tests for customer app (auth flow, booking flow)
- [ ] 6.4.7 Write Flutter widget tests for driver app (login, job workflow)

### Sprint 6.5: Deployment
- [ ] 6.5.1 Configure production environment (env vars, queues, cache, scheduler)
- [ ] 6.5.2 Set up CI/CD pipeline (GitHub Actions or similar)
- [ ] 6.5.3 Deploy backend to production server
- [ ] 6.5.4 Deploy CRM (Vite build → S3/Spaces + CDN)
- [ ] 6.5.5 Build and distribute customer APK/IPA
- [ ] 6.5.6 Build and distribute driver APK/IPA
- [ ] 6.5.7 Write deployment documentation
- [ ] 6.5.8 Write user manual (CRM + customer app + driver app)
