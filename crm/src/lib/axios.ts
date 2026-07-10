import axios from 'axios'
import * as Sentry from '@sentry/react'
import { useAuthStore } from '@/stores/auth'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api/v1',
  headers: {
    Accept: 'application/json',
  },
})

api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout()
    } else {
      Sentry.captureException(error, {
        tags: {
          api_endpoint: error.config?.url || 'unknown',
          status: String(error.response?.status ?? 'network'),
        },
      })
    }
    return Promise.reject(error)
  }
)

export default api
