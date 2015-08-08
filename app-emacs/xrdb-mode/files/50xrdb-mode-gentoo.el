(add-to-list 'load-path "@SITELISP@")
(autoload 'xrdb-mode "xrdb-mode" "Major mode for editing xrdb config files." t)
(add-to-list
 'auto-mode-alist
 '("\\.\\(Xdefaults\\|Xenvironment\\|Xresources\\|ad\\)\\'" . xrdb-mode))
