(add-to-list 'load-path "@SITELISP@")
(autoload 'typescript-mode "typescript-mode"
  "Major mode for editing typescript." t)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
