(add-to-list 'load-path "@SITELISP@")
(autoload 'editorconfig-mode "editorconfig"
  "Toggle EditorConfig feature." t)
(autoload 'editorconfig-conf-mode "editorconfig-conf-mode"
  "Major mode for editing .editorconfig files." t)
(add-to-list 'auto-mode-alist
	     '("/\\.editorconfig\\'" . editorconfig-conf-mode))
