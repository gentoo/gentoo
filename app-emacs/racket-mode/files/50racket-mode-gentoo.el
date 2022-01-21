(add-to-list 'load-path "@SITELISP@")
(autoload 'racket-mode "racket-mode"
  "Major mode for editing Racket source files." t)
(add-to-list 'auto-mode-alist '("\\.rkt\\'"  . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktd\\'" . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktl\\'" . racket-mode))

(setq racket--rkt-source-dir (expand-file-name "./racket/" "@SITEETC@"))
(setq racket--run.rkt (expand-file-name "main.rkt" racket--rkt-source-dir))
