
;; site-init for sci-mathematics/pari

(add-to-list 'load-path "@SITELISP@")

(autoload 'gp-mode "pari" nil t)
(autoload 'gp-script-mode "pari" nil t)
(autoload 'gp "pari" nil t)
(autoload 'gpman "pari" nil t)
(add-to-list 'auto-mode-alist '("\\.gp$" . gp-script-mode))
