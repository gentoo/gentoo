(add-to-list 'load-path "@SITELISP@")
(autoload 'powershell "powershell"
  "Run an inferior PowerShell." t)
(autoload 'powershell-mode "powershell"
  "Major mode for editing PowerShell scripts." t)
(add-to-list 'auto-mode-alist '("\\.ps[dm]?1\\'" . powershell-mode))
