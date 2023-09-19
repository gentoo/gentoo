(add-to-list 'load-path "@SITELISP@")
(autoload 'flycheck-package-setup "flycheck-package"
  "Setup flycheck-package." t nil)
(eval-after-load 'flycheck '(flycheck-package-setup))
