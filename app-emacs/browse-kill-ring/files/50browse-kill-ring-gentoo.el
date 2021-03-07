(add-to-list 'load-path "@SITELISP@")
(autoload 'browse-kill-ring "browse-kill-ring"
  "Display items in the `kill-ring' in another buffer." t)
(autoload 'browse-kill-ring-default-keybindings "browse-kill-ring"
  "Set up M-y (`yank-pop') so that it can invoke `browse-kill-ring'." t)
