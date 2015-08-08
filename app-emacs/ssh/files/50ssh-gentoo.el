(add-to-list 'load-path "@SITELISP@")
(add-to-list 'same-window-regexps "^\\*ssh-.*\\*\\(\\|<[0-9]+>\\)")
(autoload 'ssh "ssh" "Open a network login connection via `ssh'" t)
