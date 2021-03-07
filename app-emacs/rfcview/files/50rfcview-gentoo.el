(add-to-list 'load-path "@SITELISP@")
(autoload 'rfcview-mode "rfcview" nil t)
(add-to-list 'auto-mode-alist
	     '("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode))
