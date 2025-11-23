(add-to-list 'load-path "@SITELISP@")

(autoload 'w3m-nav-go-top "w3mnav" nil t)
(autoload 'w3m-nav-go-prev "w3mnav" nil t)
(autoload 'w3m-nav-go-next "w3mnav" nil t)

(add-hook 'w3m-mode-hook
	  (lambda ()
	    (setq w3m-mode-map w3m-info-like-map)
	    (define-key w3m-mode-map "t" 'w3m-nav-go-top)
	    (define-key w3m-mode-map "[" 'w3m-nav-go-prev)
	    (define-key w3m-mode-map "]" 'w3m-nav-go-next)))
