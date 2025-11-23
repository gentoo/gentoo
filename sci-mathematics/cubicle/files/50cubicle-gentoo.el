(add-to-list 'load-path "@SITELISP@")
(autoload 'cubicle-mode "cubicle-mode"
  "A major mode for editing Cubicle files." t)
(add-to-list 'auto-mode-alist '("\\.cub\\'" . cubicle-mode))
