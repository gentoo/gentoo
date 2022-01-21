(add-to-list 'load-path "@SITELISP@")
(autoload 'racket-mode "racket-mode"
  "Major mode for editing Racket source files." t)
(add-to-list 'auto-mode-alist '("\\.rkt\\'"  . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktd\\'" . racket-mode))
(add-to-list 'auto-mode-alist '("\\.rktl\\'" . racket-mode))
