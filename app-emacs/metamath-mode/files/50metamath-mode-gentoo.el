(add-to-list 'load-path "@SITELISP@")
(autoload 'metamath-mode "metamath-mode"
  "Major mode for editing metamath files" t)
(add-to-list 'auto-mode-alist '("\\.mm\\'" . metamath-mode))
