(add-to-list 'load-path "@SITELISP@")
(autoload 'ein:ipynb-mode "ein-ipynb-mode"
  "A simple mode for ipynb file." t)
(add-to-list 'auto-mode-alist '("\\.ipynb\\'" . ein:ipynb-mode))
