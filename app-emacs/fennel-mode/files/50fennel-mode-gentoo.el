(add-to-list 'load-path "@SITELISP@")
(autoload 'fennel-mode "fennel-mode"
  "Major mode for editing Fennel code." t)
(add-to-list 'auto-mode-alist '("\\.fnl\\'" . fennel-mode))
