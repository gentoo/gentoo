
;;; dev-util/bzr site-lisp configuration

(unless (fboundp 'vc-bzr-registered)
     (add-to-list 'load-path "@SITELISP@"))
