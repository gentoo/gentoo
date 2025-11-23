(add-to-list 'load-path "@SITELISP@")
(autoload 'earthfile-mode "earthfile-mode.el"
  "A major mode for editing Earthfile file." t)
(add-to-list 'auto-mode-alist '("Earthfile\\'" . earthfile-mode))
(add-to-list 'auto-mode-alist '("\\.earth\\'" . earthfile-mode))
