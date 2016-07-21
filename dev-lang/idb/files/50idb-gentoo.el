
;;; idb site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'idb "idb" "Run idb on program <FILE> in buffer *gud-<FILE>*." t)
