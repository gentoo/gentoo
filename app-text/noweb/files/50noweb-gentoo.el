(add-to-list 'load-path "@SITELISP@")
(autoload  'noweb-mode "noweb-mode"
  "Minor meta mode for editing noweb files." t)
(add-to-list 'auto-mode-alist '("\\.nw\\'" . noweb-mode))
