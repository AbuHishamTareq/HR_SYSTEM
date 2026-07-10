import { useTranslation } from 'react-i18next'
import { Card } from '@/components/ui/Card'

const stats = [
  { key: 'today_orders', value: '24', change: '+12%', positive: true },
  { key: 'active_orders', value: '8', change: '-3%', positive: false },
  { key: 'completed_orders', value: '156', change: '+8%', positive: true },
  { key: 'revenue', value: 'SAR 12,450', change: '+15%', positive: true },
]

const quickActions = [
  { label: 'New Booking', href: '/bookings/new', icon: 'M12 4v16m8-8H4' },
  { label: 'Dispatch Driver', href: '/dispatch', icon: 'M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z' },
  { label: 'View Reports', href: '/reports', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z' },
  { label: 'Settings', href: '/settings', icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z' },
]

export function DashboardPage() {
  const { t } = useTranslation()

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-[var(--text-primary)]">{t('nav.dashboard')}</h1>
        <p className="text-sm text-[var(--text-muted)] mt-1">
          Overview of your business metrics
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat) => (
          <Card key={stat.key} padding="md">
            <p className="text-sm text-[var(--text-muted)]">{t(`dashboard.${stat.key}`)}</p>
            <p className="text-2xl font-bold text-[var(--text-primary)] mt-1">{stat.value}</p>
            <span
              className={`inline-flex items-center text-xs font-medium mt-2 ${
                stat.positive ? 'text-green-600' : 'text-red-600'
              }`}
            >
              {stat.change}
            </span>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card padding="md">
          <h2 className="text-lg font-semibold text-[var(--text-primary)] mb-4">Quick Actions</h2>
          <div className="grid grid-cols-2 gap-3">
            {quickActions.map((action) => (
              <a
                key={action.label}
                href={action.href}
                className="flex items-center gap-3 p-3 rounded-lg bg-[var(--bg-tertiary)] hover:bg-[var(--border-color)] transition-colors text-sm font-medium text-[var(--text-primary)]"
              >
                <svg className="w-5 h-5 text-[var(--color-primary)]" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d={action.icon} />
                </svg>
                {action.label}
              </a>
            ))}
          </div>
        </Card>

        <Card padding="md">
          <h2 className="text-lg font-semibold text-[var(--text-primary)] mb-4">Recent Activity</h2>
          <div className="space-y-3">
            {[1, 2, 3, 4].map((i) => (
              <div key={i} className="flex items-center gap-3 text-sm">
                <div className="w-2 h-2 rounded-full bg-[var(--color-primary)]" />
                <p className="text-[var(--text-secondary)]">New booking #{1000 + i} created</p>
                <span className="ml-auto text-xs text-[var(--text-muted)]">{i * 5}m ago</span>
              </div>
            ))}
          </div>
        </Card>
      </div>
    </div>
  )
}
