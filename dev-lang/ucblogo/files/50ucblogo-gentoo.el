
;;; ucblogo site-lisp configuration

(add-to-list 'load-path "/usr/lib/logo/emacs")
(autoload 'logo-mode "logo" nil t)
(add-to-list 'auto-mode-alist '("\\.lgo?\\'" . logo-mode))

(setq logo-help-path "/usr/lib/logo/helpfiles/")
(setq logo-tutorial-path "/usr/lib/logo/emacs/")
(setq logo-info-file "/usr/share/info/ucblogo.info")
;; font/color defaults are intrusive, disable them
(setq dont-mess-with-logo-colors t)
