(add-to-list 'load-path "@SITELISP@")
(autoload 'd-mode "d-mode" "Major mode for editing D code" t)
(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
