(add-to-list 'load-path "@SITELISP@")
(autoload 'desktop-entry-mode "desktop-entry-mode" "Desktop Entry mode" t)
(add-to-list 'auto-mode-alist
 '("\\.desktop\\(\\.in\\)?$" . desktop-entry-mode))
(add-hook 'desktop-entry-mode-hook 'turn-on-font-lock)
