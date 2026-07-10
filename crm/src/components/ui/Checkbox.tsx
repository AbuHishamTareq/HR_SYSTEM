import { InputHTMLAttributes, forwardRef, useId } from 'react'

interface CheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> {
  label?: string
}

export const Checkbox = forwardRef<HTMLInputElement, CheckboxProps>(
  ({ label, id, className = '', ...props }, ref) => {
    const generatedId = useId()
    const checkboxId = id || generatedId

    return (
      <label
        htmlFor={checkboxId}
        className={`group inline-flex items-center gap-2 cursor-pointer select-none ${className}`}
      >
        <span className="relative flex items-center justify-center w-4 h-4 shrink-0">
          <input
            ref={ref}
            id={checkboxId}
            type="checkbox"
            className="peer sr-only"
            {...props}
          />
          <span
            className="absolute inset-0 rounded border border-[var(--border-color)] 
                       bg-[var(--bg-primary)] transition-all duration-150
                       peer-checked:bg-[var(--color-primary)] peer-checked:border-[var(--color-primary)]
                       peer-focus-visible:ring-2 peer-focus-visible:ring-[var(--color-primary)] 
                       peer-focus-visible:ring-offset-1 peer-focus-visible:ring-offset-[var(--bg-primary)]
                       group-hover:border-[var(--color-primary)]"
          />
          <svg
            className="relative w-3 h-3 text-white opacity-0 peer-checked:opacity-100 
                       transition-opacity duration-150 pointer-events-none"
            viewBox="0 0 12 12"
            fill="none"
            aria-hidden="true"
          >
            <path
              d="M2 6L5 9L10 3"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </span>
        {label && (
          <span className="text-sm text-[var(--text-secondary)]">{label}</span>
        )}
      </label>
    )
  }
)

Checkbox.displayName = 'Checkbox'
