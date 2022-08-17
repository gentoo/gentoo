(add-to-list 'load-path "@SITELISP@")
(autoload 'connect-to-guile "geiser-guile"
  "Start a Guile REPL connected to a remote process." t)
(autoload 'run-guile "geiser-guile"
  "Start a Geiser Guile REPL." t)
(autoload 'switch-to-guile "geiser-guile"
  "Start a Geiser Guile REPL, or switch to a running one." t)
