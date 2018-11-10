
;;; puppet-mode site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
