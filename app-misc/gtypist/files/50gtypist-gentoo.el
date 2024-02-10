
;; gtypist site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'gtypist-mode "gtypist-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.typ\\'" . gtypist-mode))
