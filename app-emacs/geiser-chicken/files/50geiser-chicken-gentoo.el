(add-to-list 'load-path "@SITELISP@")
(autoload 'connect-to-chicken "geiser-chicken"
  "Connect to a remote Geiser Chicken REPL." t)
(autoload 'run-chicken "geiser-chicken"
  "Start a Geiser Chicken REPL." t)
(autoload 'switch-to-chicken "geiser-chicken"
  "Start a Geiser Chicken REPL, or switch to a running one." t)
