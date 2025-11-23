(add-to-list 'load-path "@SITELISP@")
(autoload 'run-chez "geiser-chez"
  "Start a Geiser Chez REPL." t)
(autoload 'switch-to-chez "geiser-chez"
  "Start a Geiser Chez REPL, or switch to a running one." t)
