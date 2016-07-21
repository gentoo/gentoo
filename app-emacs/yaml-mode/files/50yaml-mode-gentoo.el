(add-to-list 'load-path "@SITELISP@")
(autoload 'yaml-mode "yaml-mode" "Simple mode to edit YAML." t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
