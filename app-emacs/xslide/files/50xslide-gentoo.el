(add-to-list 'load-path "@SITELISP@")
(autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)
;; Turn on font lock when in XSL mode
(add-hook 'xsl-mode-hook
	  'turn-on-font-lock)
(add-to-list 'auto-mode-alist
	     '("\\.fo\\'\\|\\.xsl\\'" . xsl-mode))
