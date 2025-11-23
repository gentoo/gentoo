(add-to-list 'load-path "@SITELISP@")
(autoload 'ninja-mode "ninja-mode" "ninja" t)
(add-to-list 'auto-mode-alist '("\\.ninja$" . ninja-mode))
