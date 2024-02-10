(add-to-list 'load-path "@SITELISP@")
(autoload 'cask-mode "cask-mode"
  "Major mode for editing Cask files." t)
(add-to-list 'auto-mode-alist '("/Cask\\'" . cask-mode))
