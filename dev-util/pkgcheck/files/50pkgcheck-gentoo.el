(add-to-list 'load-path "@SITELISP@")
(autoload 'flycheck-pkgcheck-setup "flycheck-pkgcheck"
  "Flycheck pkgcheck setup." t)
(add-hook 'ebuild-mode-hook 'flycheck-pkgcheck-setup)
