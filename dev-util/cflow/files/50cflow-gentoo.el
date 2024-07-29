
;;; cflow site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'cflow-mode "cflow-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.cflow\\'" . cflow-mode))
