(add-to-list 'load-path "@SITELISP@")

(autoload 'racket-bug-report "racket-bug-report"
  "Fill a buffer with data to make a racket-mode bug report." t)
(autoload 'racket-mode "racket-mode"
  "Major mode for editing Racket source files." t)
(autoload 'racket-repl "racket-repl"
  "Run the Racket REPL and display its buffer in some window." t)
(autoload 'racket-unicode-input-method-enable "racket-unicode-input-method"
  "Set input method to `racket-unicode`." t)

(add-to-list 'auto-mode-alist '("\\.rkt\\'"  . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktd\\'" . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktl\\'" . racket-mode))
