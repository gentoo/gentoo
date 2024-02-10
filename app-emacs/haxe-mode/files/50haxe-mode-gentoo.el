(add-to-list 'load-path "@SITELISP@")
(autoload 'haxe-mode "haxe-mode"
  "Major mode for editing Haxe code." t)
(add-to-list 'auto-mode-alist '("\\.hx\\'" . haxe-mode))
