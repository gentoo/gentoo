(add-to-list 'load-path "@SITELISP@")
(autoload 'quilt-mode "quilt"
  "Toggle quilt-mode. With positive arg, enable quilt-mode." t)
(autoload 'quilt-hook "quilt"
  "Enable quilt mode for quilt-controlled files.")
(add-hook 'find-file-hooks 'quilt-hook)
(add-hook 'after-revert-hook 'quilt-hook)
