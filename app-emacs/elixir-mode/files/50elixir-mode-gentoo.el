(add-to-list 'load-path "@SITELISP@")
(autoload 'elixir-mode "elixir-mode"
  "Major mode for editing Elixir code." t)
(add-to-list 'auto-mode-alist '("\\.elixir\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.ex\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.exs\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("mix\\.lock" . elixir-mode))
