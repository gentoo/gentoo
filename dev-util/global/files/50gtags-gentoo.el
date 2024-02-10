
;;; global site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'gtags-mode "gtags"
  "Toggle Gtags mode, a minor mode for browsing source code using GLOBAL." t)
