(add-to-list 'load-path "@SITELISP@")
(autoload 'eselect-mode "eselect-mode" "Major mode for .eselect files." t)
(add-to-list 'auto-mode-alist '("\\.eselect\\'" . eselect-mode))
