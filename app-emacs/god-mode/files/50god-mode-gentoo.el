(add-to-list 'load-path "@SITELISP@")
(autoload 'god-execute-with-current-bindings "god-mode"
  "Execute a single command from God mode, preserving current keybindings." t)
(autoload 'god-local-mode "god-mode"
  "Minor mode for running commands." t)
(autoload 'god-mode "god-mode"
  "Toggle global `god-local-mode'." t)
(autoload 'god-mode-all "god-mode"
  "Toggle `god-local-mode' in all buffers." t)
