;;; Flycheck site-lisp configuration
(add-to-list 'load-path "@SITELISP@")
(autoload 'flycheck-mode "flycheck" nil t)
(autoload 'global-flycheck-mode "flycheck" nil t)
