(add-to-list 'load-path "@SITELISP@")
(autoload 'julia-mode "julia-mode"
  "Major mode for editing julia code." t)
(add-to-list 'auto-mode-alist '("\\.jl\\'" . julia-mode))
