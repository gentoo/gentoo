
;;; form site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.frm\\'" . form-mode))
(autoload 'form-mode "form-mode" "Major mode for form files." t)
