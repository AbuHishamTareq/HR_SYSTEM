import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import * as Sentry from '@sentry/react'
import { router } from './router'
import { useThemeStore } from '@/stores/theme'
import { useLocaleStore } from '@/stores/locale'
import { initSentry } from '@/lib/sentry'
import { ErrorFallback } from '@/components/sentry/ErrorFallback'
import './i18n'
import './index.css'

initSentry()

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      staleTime: 5 * 60 * 1000,
      refetchOnWindowFocus: false,
    },
  },
})

// Apply persisted theme and locale on load
const theme = useThemeStore.getState().theme
if (theme === 'dark') {
  document.documentElement.classList.add('dark')
}
const locale = useLocaleStore.getState().locale
document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr'
document.documentElement.lang = locale

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <Sentry.ErrorBoundary fallback={ErrorFallback}>
      <QueryClientProvider client={queryClient}>
        <RouterProvider router={router} />
      </QueryClientProvider>
    </Sentry.ErrorBoundary>
  </StrictMode>
)
