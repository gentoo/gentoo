(add-to-list 'load-path "@SITELISP@")
(autoload 'jq-mode "jq-mode"
  "Major mode for editing jq files" t)
(add-to-list 'auto-mode-alist '("\\.jq\\'" . jq-mode))
