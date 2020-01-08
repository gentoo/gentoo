(add-to-list 'load-path "@SITELISP@")
(autoload 'desktop+-create "desktop+"
  "Create a new session, identified by a name." t)
(autoload 'desktop+-load "desktop+"
  "Load a session previously created using `desktop+-create'." t)
(autoload 'desktop+-create-auto "desktop+"
  "Create a new session, identified by the current working directory." t)
(autoload 'desktop+-load-auto "desktop+"
  "Load a session previously created using `desktop+-create-auto'." t)
