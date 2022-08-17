(add-to-list 'load-path "@SITELISP@")
(autoload 'dune-mode "dune"
  "Major mode to edit dune files." t)
(add-to-list 'auto-mode-alist '("\\(?:\\`\\|/\\)dune\\(?:\\.inc\\|\\-project\\)?\\'" . dune-mode))
