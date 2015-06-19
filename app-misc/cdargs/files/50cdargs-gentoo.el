
;;; app-misc/cdargs site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'cdargs "cdargs"
  "Change the current working directory using a bookmarks file." t)
(defalias 'cv 'cdargs)
(autoload 'cdargs-edit "cdargs" "Simply open the bookmarks file" t)
