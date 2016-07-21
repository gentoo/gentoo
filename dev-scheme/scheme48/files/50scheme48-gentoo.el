;;; scheme48 site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(setq scheme-program-name "scheme48")
(autoload 'run-scheme
	  "cmuscheme48"
	  "Run an inferior Scheme process."
	  t)

