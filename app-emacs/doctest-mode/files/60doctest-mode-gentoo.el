(add-to-list 'load-path "@SITELISP@")
(autoload 'doctest-mode "doctest-mode"
  "Editing mode for Python Doctest examples." t)
(add-to-list 'auto-mode-alist '("\\.doctest\\'" . doctest-mode))
