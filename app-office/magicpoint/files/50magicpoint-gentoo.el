
;;; magicpoint site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'mgp-mode "mgp-mode" "MagicPoint editor mode" t)
(add-to-list 'auto-mode-alist '("\\.mgp\\'" . mgp-mode))
