
;;; pspp site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'pspp-mode "pspp-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.sps\\'" . pspp-mode))
