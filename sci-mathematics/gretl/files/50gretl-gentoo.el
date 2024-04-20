
;;; sci-mathematics/gretl site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'gretl-mode "gretl" nil t)
;; not adding to auto-mode-alist since .inp is too generic as extension
;;(add-to-list 'auto-mode-alist '("\\.inp\\'" . gretl-mode))

;; Automatically turn on the abbrev, auto-fill and font-lock features
(add-hook 'gretl-mode-hook
	  (lambda ()
	    (abbrev-mode 1)
	    (auto-fill-mode 1)
	    (if (eq window-system 'x)
		(font-lock-mode 1))))
