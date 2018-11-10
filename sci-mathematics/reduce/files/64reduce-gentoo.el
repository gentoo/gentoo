;; site-init for sci-mathematics/reduce
(add-to-list 'load-path "@SITELISP@")
(autoload 'reduce-mode "reduce-mode" "Major mode for REDUCE code editing" t)
(add-to-list 'auto-mode-alist '("\\.red\\'" . reduce-mode))
