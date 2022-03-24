(add-to-list 'load-path "@SITELISP@")
(autoload 'julia-repl-mode "julia-repl"
  "Minor mode for interacting with a Julia REPL running inside a term." t)
(add-hook 'julia-mode-hook 'julia-repl-mode)
