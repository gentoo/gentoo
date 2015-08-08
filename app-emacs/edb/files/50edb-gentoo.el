(add-to-list 'load-path "@SITELISP@")
(autoload 'db-find-file "database" "EDB database package" t)
(autoload 'edb-interact "database" "EDB database package" t)
(defalias 'edb-EXPERIMENTAL-interact 'edb-interact)
