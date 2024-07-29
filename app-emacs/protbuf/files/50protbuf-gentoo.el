(add-to-list 'load-path "@SITELISP@")

(autoload 'protect-buffer-from-kill-mode "protbuf"
  "Protect buffer from being killed.
To remove this protection, call this command with a negative prefix argument."
  t)
(autoload 'protect-process-buffer-from-kill-mode "protbuf"
  "Protect buffer from being killed as long as it has an active process.
To remove this protection, call this command with a negative prefix argument."
  t)
(autoload 'protect-buffer-from-kill "protbuf")
(autoload 'protect-process-buffer-from-kill "protbuf")
