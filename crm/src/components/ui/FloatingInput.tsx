import { InputHTMLAttributes, forwardRef, useId } from 'react'

interface FloatingInputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'placeholder'> {
  label: string
  error?: string
  startIcon?: React.ReactNode
  endIcon?: React.ReactNode
  onEndIconClick?: () => void
}

export const FloatingInput = forwardRef<HTMLInputElement, FloatingInputProps>(
  (
    {
      label,
      error,
      startIcon,
      endIcon,
      onEndIconClick,
      id,
      className = '',
      ...props
    },
    ref
  ) => {
    const generatedId = useId()
    const inputId = id || generatedId

    return (
      <div className="w-full">
        <div className="floating-input-wrapper">
          {/* Start icon (always leading side) */}
          {startIcon && (
            <div
              className="absolute start-0 flex items-center ps-3 z-10 
                          pointer-events-none text-[var(--text-muted)]"
              style={{
                top: 'calc(1rem + 1px)',
                bottom: 'calc(0.25rem + 1px)',
              }}
              aria-hidden="true"
            >
              {startIcon}
            </div>
          )}

          {/* The actual input */}
          <input
            ref={ref}
            id={inputId}
            placeholder=" "
            className={`floating-input ${error ? 'has-error' : ''} ${className}`}
            {...props}
          />

          {/* End icon / action button (always trailing side) */}
          {endIcon && (
            <button
              type="button"
              className="absolute end-0 flex items-center pe-3 z-10 
                         text-[var(--text-muted)] hover:text-[var(--text-primary)] 
                         transition-colors duration-150"
              style={{
                top: 'calc(1rem + 1px)',
                bottom: 'calc(0.25rem + 1px)',
              }}
              onClick={onEndIconClick}
              tabIndex={-1}
              aria-label={label}
            >
              {endIcon}
            </button>
          )}

          {/* Floating label */}
          <label htmlFor={inputId} className="floating-label">
            {label}
          </label>
        </div>

        {/* Error message */}
        {error && (
          <p className="mt-1.5 text-xs text-[var(--color-danger)] error-animate flex items-center gap-1">
            <svg
              className="w-3.5 h-3.5 shrink-0"
              viewBox="0 0 16 16"
              fill="currentColor"
              aria-hidden="true"
            >
              <path d="M8 1C4.14 1 1 4.14 1 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm0 
                       11a.75.75 0 110-1.5.75.75 0 010 1.5zm.75-3a.75.75 0 01-1.5 
                       0V5.5a.75.75 0 011.5 0V9z" />
            </svg>
            <span>{error}</span>
          </p>
        )}
      </div>
    )
  }
)

FloatingInput.displayName = 'FloatingInput'
