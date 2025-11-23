(add-to-list 'load-path "@SITELISP@")
(autoload 'flycheck-nimsuggest-setup "flycheck-nimsuggest"
  "Setup flycheck configuration for nimsuggest.")
(add-hook 'nimsuggest-mode-hook 'flycheck-nimsuggest-setup)
