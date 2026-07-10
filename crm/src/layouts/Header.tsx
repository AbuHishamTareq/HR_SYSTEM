import { useTranslation } from 'react-i18next'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'
import { useLocaleStore } from '@/stores/locale'
import { useSidebarStore } from '@/stores/sidebar'
import { useLogout } from '@/hooks/useAuth'
import { Button } from '@/components/ui/Button'

export function Header() {
  const { t, i18n } = useTranslation()
  const user = useAuthStore((s) => s.user)
  const { theme, toggleTheme } = useThemeStore()
  const { locale, setLocale } = useLocaleStore()
  const { toggle, isCollapsed, toggleCollapse } = useSidebarStore()
  const logoutMutation = useLogout()

  const switchLocale = () => {
    const next = locale === 'en' ? 'ar' : 'en'
    setLocale(next)
    i18n.changeLanguage(next)
  }

  return (
    <header className="sticky top-0 z-30 h-16 bg-[var(--bg-primary)] border-b border-[var(--border-color)]">
      <div className="flex items-center justify-between h-full px-4 gap-4">
        <div className="flex items-center gap-3">
          <button
            onClick={toggle}
            className="lg:hidden p-2 rounded-lg text-[var(--text-secondary)] hover:bg-[var(--bg-tertiary)]"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
            </svg>
          </button>
          <button
            onClick={toggleCollapse}
            className="hidden lg:block p-2 rounded-lg text-[var(--text-secondary)] hover:bg-[var(--bg-tertiary)]"
          >
            <svg
              className={`w-5 h-5 transition-transform ${isCollapsed ? 'rotate-180' : ''}`}
              fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}
            >
              <path strokeLinecap="round" strokeLinejoin="round" d="M18.75 19.5l-7.5-7.5 7.5-7.5m-6 15L5.25 12l7.5-7.5" />
            </svg>
          </button>
        </div>

        <div className="flex items-center gap-2">
          <Button variant="ghost" size="sm" onClick={switchLocale}>
            {locale === 'en' ? 'العربية' : 'English'}
          </Button>

          <Button variant="ghost" size="sm" onClick={toggleTheme}>
            {theme === 'light' ? (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z" />
              </svg>
            )}
          </Button>

          <div className="flex items-center gap-3 ml-3 pl-3 border-l border-[var(--border-color)]">
            <div className="text-right">
              <p className="text-sm font-medium text-[var(--text-primary)]">{user?.name}</p>
              <p className="text-xs text-[var(--text-muted)]">{user?.email}</p>
            </div>
            <button
              onClick={() => logoutMutation.mutate()}
              className="p-2 rounded-lg text-[var(--text-secondary)] hover:bg-[var(--bg-tertiary)]"
              title={t('auth.logout')}
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </header>
  )
}
