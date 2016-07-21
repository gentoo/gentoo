
;;; rnc-mode site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'rnc-mode "rnc-mode")
(add-to-list 'auto-mode-alist '("\\.rnc\\'" . rnc-mode))
