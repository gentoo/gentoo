;;; lisaac site-lisp configuration
(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.li\\'" . lisaac-mode))
(autoload 'lisaac-mode "lisaac-mode" "Major mode for Lisaac Programs" t)
