(add-to-list 'load-path "@SITELISP@")
(autoload 'conditionally-turn-on-pandoc "pandoc-mode"
  "Turn on pandoc-mode if a pandoc settings file exists.")  ; non-interactive
(autoload 'pandoc-mode "pandoc-mode"
  "Minor mode for interacting with Pandoc." t)
