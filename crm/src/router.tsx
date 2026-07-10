import { createBrowserRouter, Navigate } from 'react-router-dom'
import * as Sentry from '@sentry/react'
import { AuthGuard } from '@/layouts/AuthGuard'
import { ProtectedLayout } from '@/layouts/ProtectedLayout'
import { LoginPage } from '@/features/auth/LoginPage'
import { DashboardPage } from '@/pages/DashboardPage'

const sentryCreateBrowserRouter = Sentry.wrapCreateBrowserRouter(createBrowserRouter)

export const router = sentryCreateBrowserRouter([
  {
    path: '/login',
    element: <LoginPage />,
  },
  {
    path: '/',
    element: <AuthGuard />,
    children: [
      {
        element: <ProtectedLayout />,
        children: [
          { index: true, element: <DashboardPage /> },
          { path: 'bookings', element: <div className="text-[var(--text-muted)]">Bookings page coming soon</div> },
          { path: 'contracts', element: <div className="text-[var(--text-muted)]">Contracts page coming soon</div> },
          { path: 'dispatch', element: <div className="text-[var(--text-muted)]">Dispatch page coming soon</div> },
          { path: 'schedule', element: <div className="text-[var(--text-muted)]">Schedule page coming soon</div> },
          { path: 'customers', element: <div className="text-[var(--text-muted)]">Customers page coming soon</div> },
          { path: 'drivers', element: <div className="text-[var(--text-muted)]">Drivers page coming soon</div> },
          { path: 'services', element: <div className="text-[var(--text-muted)]">Services page coming soon</div> },
          { path: 'promotions', element: <div className="text-[var(--text-muted)]">Promotions page coming soon</div> },
          { path: 'hr', element: <div className="text-[var(--text-muted)]">HR page coming soon</div> },
          { path: 'accounting', element: <div className="text-[var(--text-muted)]">Accounting page coming soon</div> },
          { path: 'reports', element: <div className="text-[var(--text-muted)]">Reports page coming soon</div> },
          { path: 'settings', element: <div className="text-[var(--text-muted)]">Settings page coming soon</div> },
        ],
      },
    ],
  },
  {
    path: '*',
    element: <Navigate to="/" replace />,
  },
])
