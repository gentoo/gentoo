(add-to-list 'load-path "@SITELISP@")
(autoload 'scss-mode "scss-mode" "Simple mode to edit SCSS." t)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
