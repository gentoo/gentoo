
;;; gnu-smalltalk site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'smalltalk-mode "smalltalk-mode" "Autoload for smalltalk-mode" t)
(autoload 'gst "gst-mode" "Autoload for gst" t)
(add-to-list 'auto-mode-alist '("\\.st\\'" . smalltalk-mode))
