import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useTranslation } from 'react-i18next'
import { isAxiosError } from 'axios'
import { useLogin } from '@/hooks/useAuth'
import { Button } from '@/components/ui/Button'
import { FloatingInput } from '@/components/ui/FloatingInput'
import { Checkbox } from '@/components/ui/Checkbox'
import './login.css'

/* ── Schema ─────────────────────────────────────────────── */

const loginSchema = z.object({
  email: z.string().email('Please enter a valid email'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  rememberMe: z.boolean().optional(),
})

type LoginForm = z.infer<typeof loginSchema>

/* ── SVG Icons (inline — no external icon library) ──────── */

const EnvelopeIcon = () => (
  <svg
    width="18"
    height="18"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <rect x="2" y="4" width="20" height="16" rx="2" />
    <path d="M22 4L12 13L2 4" />
  </svg>
)

const LockIcon = () => (
  <svg
    width="18"
    height="18"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <rect x="5" y="11" width="14" height="10" rx="2" />
    <path d="M8 11V7a4 4 0 118 0v4" />
  </svg>
)

const EyeIcon = () => (
  <svg
    width="18"
    height="18"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
    <circle cx="12" cy="12" r="3" />
  </svg>
)

const EyeOffIcon = () => (
  <svg
    width="18"
    height="18"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94" />
    <path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19" />
    <line x1="1" y1="1" x2="23" y2="23" />
    <path d="M14.12 14.12a3 3 0 11-4.24-4.24" />
  </svg>
)

const ArrowRightIcon = () => (
  <svg
    width="18"
    height="18"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <line x1="5" y1="12" x2="19" y2="12" />
    <polyline points="12 5 19 12 12 19" />
  </svg>
)

const LogoIcon = () => (
  <svg
    width="48"
    height="48"
    viewBox="0 0 48 48"
    fill="none"
  >
    <defs>
      <linearGradient id="logo-grad" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0%" stopColor="var(--color-primary)" />
        <stop offset="100%" stopColor="#4f46e5" />
      </linearGradient>
    </defs>
    <rect width="48" height="48" rx="12" fill="url(#logo-grad)" />
    {/* Stylized H */}
    <path
      d="M15 34V14h3.5v7.5h11V14H33v20h-3.5v-9h-11v9H15z"
      fill="white"
    />
    {/* Gear accent dot */}
    <circle cx="38" cy="10" r="5" fill="white" opacity="0.25" />
    <circle cx="38" cy="10" r="2.5" fill="url(#logo-grad)" />
  </svg>
)

/* ── Error helper ────────────────────────────────────────── */

function getErrorMessage(error: unknown): string {
  if (isAxiosError(error)) {
    // Network/server error — no response received
    if (!error.response) {
      return 'Connection error. Please check your internet and try again.'
    }

    const { status, data } = error.response

    // Validation errors (422)
    if (status === 422) {
      const errors = data?.errors
      if (errors) {
        // Return the first validation error message
        const firstError = Object.values(errors).flat()[0]
        if (typeof firstError === 'string') return firstError
      }
      return data?.message || 'Validation failed.'
    }

    // Authentication errors (401)
    if (status === 401) {
      return 'Invalid email or password.'
    }

    // Server errors (5xx) or other unexpected statuses
    if (status >= 500) {
      return 'Connection error. Please try again.'
    }

    // Fallback: use the API's message if available
    return data?.message || 'An unexpected error occurred.'
  }

  return 'An unexpected error occurred.'
}

/* ── Page Component ─────────────────────────────────────── */

export function LoginPage() {
  const { t, i18n } = useTranslation()
  const loginMutation = useLogin()
  const [showPassword, setShowPassword] = useState(false)
  const isRtl = i18n.dir() === 'rtl'

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
  })

  const onSubmit = (data: LoginForm) => {
    loginMutation.mutate(data)
  }

  return (
    <div className="login-page">
      {/* Animated background orbs — subtle, floating gradients */}
      <div className="bg-orb bg-orb--1" aria-hidden="true" />
      <div className="bg-orb bg-orb--2" aria-hidden="true" />
      <div className="bg-orb bg-orb--3" aria-hidden="true" />
      {/* Themed floating shapes — bubbles + HR/home-services icons */}
      <div className="bg-theme bg-theme--bubble-1" aria-hidden="true" />
      <div className="bg-theme bg-theme--bubble-2" aria-hidden="true" />
      <div className="bg-theme bg-theme--bubble-3" aria-hidden="true" />
      <div className="bg-theme bg-theme--bubble-4" aria-hidden="true" />
      <div className="bg-theme bg-theme--house" aria-hidden="true" />
      <div className="bg-theme bg-theme--shield" aria-hidden="true" />
      <div className="bg-theme bg-theme--heart" aria-hidden="true" />
      <div className="login-container">
        <div className="login-card">
          {/* Brand header — small, elegant */}
          <div className="text-center mb-6">
            <div className="inline-flex items-center justify-center mb-3">
              <LogoIcon />
            </div>
            <h1 className="text-sm font-semibold text-[var(--text-muted)] tracking-widest uppercase">
              {t('auth.brand_name')}
            </h1>
          </div>

          {/* Welcome heading */}
          <div className="text-center mb-8">
            <h2 className="text-2xl sm:text-[clamp(1.5rem,4vw,1.75rem)] font-bold text-[var(--text-primary)]">
              {t('auth.welcome_back')}
            </h2>
            <p className="text-sm text-[var(--text-muted)] mt-1.5">
              {t('auth.login_subtitle')}
            </p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit(onSubmit)} noValidate>
            <div className="space-y-5">
              {/* Email */}
              <div className="form-field-animate">
                <FloatingInput
                  label={t('auth.email')}
                  type="email"
                  autoComplete="email"
                  startIcon={<EnvelopeIcon />}
                  error={errors.email?.message}
                  {...register('email')}
                />
              </div>

              {/* Password */}
              <div className="form-field-animate">
                <FloatingInput
                  label={t('auth.password')}
                  type={showPassword ? 'text' : 'password'}
                  autoComplete="current-password"
                  startIcon={<LockIcon />}
                  endIcon={showPassword ? <EyeOffIcon /> : <EyeIcon />}
                  onEndIconClick={() => setShowPassword((prev) => !prev)}
                  error={errors.password?.message}
                  {...register('password')}
                />
              </div>

              {/* Server error */}
              {loginMutation.isError && (
                <div className="error-animate">
                  <p className="text-sm text-[var(--color-danger)] flex items-center gap-1.5 bg-[var(--color-danger)]/5 rounded-lg px-3 py-2">
                    <svg
                      className="w-4 h-4 shrink-0"
                      viewBox="0 0 16 16"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path d="M8 1C4.14 1 1 4.14 1 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm0
                               11a.75.75 0 110-1.5.75.75 0 010 1.5zm.75-3a.75.75 0 01-1.5
                               0V5.5a.75.75 0 011.5 0V9z" />
                    </svg>
                    <span>{getErrorMessage(loginMutation.error)}</span>
                  </p>
                </div>
              )}

              {/* Remember Me + Forgot Password */}
              <div className="form-field-animate remember-forgot-row">
                <Checkbox
                  label={t('auth.remember_me')}
                  {...register('rememberMe')}
                />
                <a href="#" className="forgot-link">
                  {t('auth.forgot_password')}
                </a>
              </div>

              {/* Submit */}
              <div className="form-field-animate">
                <Button
                  type="submit"
                  isLoading={loginMutation.isPending}
                  className="btn-submit w-full"
                >
                  <span className="inline-flex items-center gap-2">
                    {isRtl && (
                      <span className="scale-x-[-1]">
                        <ArrowRightIcon />
                      </span>
                    )}
                    <span>{t('auth.login')}</span>
                    {!isRtl && <ArrowRightIcon />}
                  </span>
                </Button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}
