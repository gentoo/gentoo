(add-to-list 'load-path "@SITELISP@")
(autoload 'raku-mode "raku-mode"
  "Major mode for editing Raku code." t)
(add-to-list 'auto-mode-alist '("\\.nqp\\'" . raku-mode))
(add-to-list 'auto-mode-alist '("\\.p[lm]?6\\'" . raku-mode))
(add-to-list 'auto-mode-alist '("\\.raku\\(?:mod\\|test\\)?\\'" . raku-mode))
(add-to-list 'interpreter-mode-alist '("perl6\\|raku" . raku-mode))
