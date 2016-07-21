
;;; timidity++ site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'timidity "timidity" "TiMidity Interface" t)
(setq timidity-prog-path "/usr/bin/timidity")
