(add-to-list 'load-path "@SITELISP@")
(autoload 'uxntal-mode "uxntal-mode"
  "Major mode for editing Uxntal files." t)
(add-to-list 'auto-mode-alist '("\\.tal\\'" . uxntal-mode))
