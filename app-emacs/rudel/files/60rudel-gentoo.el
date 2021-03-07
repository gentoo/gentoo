(add-to-list 'load-path "@SITELISP@")
(autoload 'rudel-join-session "rudel-loaddefs"
  "Start a collaborative Rudel session" t)
(autoload 'rudel-host-session "rudel-loaddefs"
  "Host a collaborative Rudel session" t)
(autoload 'rudel-speedbar "rudel-loaddefs"
  "Show connected users and documents for the Rudel session in speedbar" t)
(autoload 'global-rudel-minor-mode "rudel-loaddefs"
  "Bindings for rudel session-level commands" t)

;;(global-set-key (kbd "C-c c j") 'rudel-join-session)

(setq rudel-icons-directory "@SITEETC@/icons/")
