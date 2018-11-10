;; sci-visualisation/epix site init file

(add-to-list 'load-path "@SITELISP@")

(autoload 'epix-mode "epix" "ePiX editing mode" t)
(autoload 'flix-mode "epix" "flix editing mode" t)
(add-to-list 'auto-mode-alist '("\\.xp\\'" . epix-mode))
(add-to-list 'auto-mode-alist '("\\.flx\\'" . flix-mode))
