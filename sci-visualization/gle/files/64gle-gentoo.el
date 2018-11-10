
;;; gle site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'gle-mode "gle-mode")
(add-to-list 'auto-mode-alist '("\\.gle\\'" . gle-mode))
