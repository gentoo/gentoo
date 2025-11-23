(add-to-list 'load-path "@SITELISP@")

(autoload 'quack-scheme-mode-hookfunc "quack")
(autoload 'quack-inferior-scheme-mode-hookfunc "quack")
(autoload 'quack-pltfile-mode "quack"
  "Major mode for viewing PLT Scheme `.plt' package files." t)

(add-hook 'scheme-mode-hook 'quack-scheme-mode-hookfunc)
(add-hook 'inferior-scheme-mode-hook 'quack-inferior-scheme-mode-hookfunc)
(add-to-list 'auto-mode-alist '("\\.plt\\'" . quack-pltfile-mode))
