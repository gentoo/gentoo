(add-to-list 'load-path "@SITELISP@")
(autoload 'lean-mode "lean-mode"
  "Major mode for editing Lean 3 source files." t)
(add-to-list 'auto-mode-alist '("\\.lean\\'" . lean-mode))
