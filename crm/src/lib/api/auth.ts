import api from '@/lib/axios'
import type { ApiResponse, AuthResponse, LoginPayload } from '@/types'

export const authApi = {
  login: (data: LoginPayload) =>
    api.post<ApiResponse<AuthResponse>>('/auth/login', data).then((r) => r.data),

  me: () =>
    api.get<ApiResponse<AuthResponse['user']>>('/auth/me').then((r) => r.data),

  logout: () =>
    api.post<ApiResponse<null>>('/auth/logout').then((r) => r.data),
}
