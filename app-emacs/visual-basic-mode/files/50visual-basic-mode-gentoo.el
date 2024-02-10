(add-to-list 'load-path "@SITELISP@")
(autoload 'visual-basic-mode "visual-basic-mode"
  "A mode for editing Visual Basic programs" t)
(add-to-list 'auto-mode-alist
	     '("\\.\\(vbs?\\|class\\.asp\\)\\'" . visual-basic-mode))
