import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import * as Sentry from '@sentry/react'
import type { User } from '@/types'

interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
  setAuth: (user: User, token: string) => void
  logout: () => void
  setUser: (user: User) => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      setAuth: (user, token) => {
        set({ user, token, isAuthenticated: true })
        Sentry.setUser({ id: String(user.id), email: user.email, username: user.name })
      },
      logout: () => {
        set({ user: null, token: null, isAuthenticated: false })
        Sentry.setUser(null)
      },
      setUser: (user) => {
        set({ user })
        Sentry.setUser({ id: String(user.id), email: user.email, username: user.name })
      },
    }),
    {
      name: 'auth-storage',
      partialize: (state) => ({ token: state.token, user: state.user, isAuthenticated: state.isAuthenticated }),
    }
  )
)
