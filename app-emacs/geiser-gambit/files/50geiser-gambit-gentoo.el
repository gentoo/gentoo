(add-to-list 'load-path "@SITELISP@")
(autoload 'connect-to-gambit "geiser-gambit"
  "Connect to a remote Geiser Gambit REPL." t)
(autoload 'run-gambit "geiser-gambit"
  "Start a Geiser Gambit REPL." t)
(autoload 'switch-to-gambit "geiser-gambit"
  "Start a Geiser Gambit REPL, or switch to a running one." t)
