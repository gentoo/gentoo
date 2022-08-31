(add-to-list 'load-path "@SITELISP@")
(autoload 'rescript-mode "rescript-mode"
  "Major mode for ReScript code." t)
(add-to-list 'auto-mode-alist '("\\.resi?\\'" . rescript-mode))
