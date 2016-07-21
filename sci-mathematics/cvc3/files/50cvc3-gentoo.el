(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.cvc\\'" . cvc-mode))
(autoload 'cvc-mode "cvc-mode" "CVC specifications editing mode." t)
