(add-to-list 'load-path "@SITELISP@")
(autoload 'dircolors "dircolors" nil t)
(add-hook 'completion-list-mode-hook 'dircolors)
(add-hook 'buffer-menu-mode-hook 'dircolors)
