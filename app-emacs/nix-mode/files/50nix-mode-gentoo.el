(add-to-list 'load-path "@SITELISP@")
(autoload 'nix-mode "nix-mode.el"
  "Major mode for editing Nix expressions." t)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
