(add-to-list 'load-path "@SITELISP@")
(autoload 'fsharp-mode "fsharp-mode"
  "Major mode for editing fsharp code." t)
(add-to-list 'auto-mode-alist '("\\.fs[iylx]?\\'" . fsharp-mode))
