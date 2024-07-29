(add-to-list 'load-path "@SITELISP@")
(autoload 'nim-mode "nim-mode"
  "A major mode for the Nim programming language." t)
(autoload 'nimscript-mode "nim-mode"
  "A major-mode for NimScript files." t)
(autoload 'nimscript-mode-maybe "nim-mode"
  "Most likely turn on ‘nimscript-mode’." t)
(autoload 'nimsuggest-mode "nim-suggest"
  "Minor mode for nimsuggest." t)
(add-to-list 'auto-mode-alist '("\\.nim\\'" . nim-mode))
(add-to-list 'auto-mode-alist '("\\.nim\\(ble\\|s\\)\\'" . nimscript-mode-maybe))
(add-hook 'nim-mode-hook 'nimsuggest-mode)
(add-hook 'nimsuggest-mode-hook 'flycheck-mode)
