
;;; gle site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.gle\\'" . gle-mode))
(autoload 'gle-mode "gle-mode" "Major mode for gle files." t)
