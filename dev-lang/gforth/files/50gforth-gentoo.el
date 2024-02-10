
;;; gforth site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'forth-mode "gforth" "Autoload for `forth-mode'." t)
(autoload 'run-forth "gforth" "Autoload for `run-forth'." t)
