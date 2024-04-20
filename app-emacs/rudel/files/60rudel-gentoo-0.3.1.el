(add-to-list 'load-path "@SITELISP@")
(autoload 'rudel-join-session "rudel"
  "Start a collaborative Rudel session" t)
(autoload 'rudel-host-session "rudel-loaddefs"
  "Host a collaborative Rudel session" t)
(autoload 'rudel-speedbar "rudel-speedbar"
  "Show connected users and documents for the Rudel session in speedbar" t)
(autoload 'global-rudel-minor-mode "rudel-mode"
  "Toggle global Rudel minor mode (No modeline indicator)." t)

;;(global-set-key (kbd "C-c c j") 'rudel-join-session)

(setq rudel-icons-directory "@SITEETC@/icons/")
