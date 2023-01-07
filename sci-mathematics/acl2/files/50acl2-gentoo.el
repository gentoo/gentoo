(add-to-list 'load-path "@SITELISP@")
(defvar *acl2-sources-dir* "/usr/share/acl2/")
(autoload 'inferior-acl2 "inf-acl2.el"
  "Run an inferior Acl2 process" t)
(autoload 'run-acl2 "inf-acl2.el"
  "Run an inferior Acl2 process" t)
