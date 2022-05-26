(add-to-list 'load-path "@SITELISP@")
(autoload 'geiser "geiser-repl"
  "Start a Geiser REPL, or switch to a running one." t)
(autoload 'geiser-mode "geiser-mode"
  "Minor mode adding Geiser REPL interaction to Scheme buffers." t)
(autoload 'run-geiser "geiser-repl"
  "Start a Geiser REPL." t)
