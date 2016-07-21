(add-to-list 'load-path "@SITELISP@")
(autoload 'gri-mode "gri-mode" "Enter Gri-mode." t)
(add-to-list 'auto-mode-alist '("\\.gri\\'" . gri-mode))
