import { create } from 'zustand'
import { persist } from 'zustand/middleware'

type Locale = 'ar' | 'en'

interface LocaleState {
  locale: Locale
  setLocale: (locale: Locale) => void
}

export const useLocaleStore = create<LocaleState>()(
  persist(
    (set) => ({
      locale: 'en',
      setLocale: (locale) => {
        document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr'
        document.documentElement.lang = locale
        set({ locale })
      },
    }),
    { name: 'locale-storage' }
  )
)
