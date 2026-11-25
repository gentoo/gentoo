(add-to-list 'load-path "@SITELISP@")
;; Taken from src/pound-mode.el
(autoload 'pound-mode "pound-mode")
(add-to-list 'auto-mode-alist
             (cons (purecopy "pound\\.cfg\\'") 'pound-mode))
