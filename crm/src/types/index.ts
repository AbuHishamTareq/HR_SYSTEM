export interface User {
  id: number
  name: string
  email: string
  phone: string | null
  locale: string
  is_active: boolean
  roles: Role[]
  created_at: string
  updated_at: string
}

export interface Role {
  id: number
  name: string
  slug: string
  permissions: Permission[]
}

export interface Permission {
  id: number
  name: string
  slug: string
}

export interface ApiResponse<T = unknown> {
  success: boolean
  message: string
  data: T
  meta?: PaginationMeta
}

export interface PaginationMeta {
  current_page: number
  last_page: number
  per_page: number
  total: number
}

export interface LoginPayload {
  email: string
  password: string
}

export interface RegisterPayload {
  name: string
  email: string
  password: string
  password_confirmation: string
  phone?: string
}

export interface AuthResponse {
  user: User
  token: string
}
