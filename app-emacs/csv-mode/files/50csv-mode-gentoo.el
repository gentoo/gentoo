(add-to-list 'load-path "@SITELISP@")
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
