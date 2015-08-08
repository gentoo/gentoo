(add-to-list 'load-path "@SITELISP@")
(autoload 'jasmin-mode "jasmin"
  "Major mode for editing Jasmin Java bytecode assembler files." t)
(add-to-list 'auto-mode-alist '("\\.j\\'" . jasmin-mode))
