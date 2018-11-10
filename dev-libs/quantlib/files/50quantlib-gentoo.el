
;;; quantlib site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'ql-new-header "quantlib" nil t)
(autoload 'ql-new-source "quantlib" nil t)
