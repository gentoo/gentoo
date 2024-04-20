(add-to-list 'load-path "@SITELISP@")
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

(setq mew-icon-directory "@SITEETC@")
(setq mew-pop-port "pop-3")
(setq mew-imap-port "imap2")
