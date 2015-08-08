(add-to-list 'load-path "@SITELISP@")

;; dir-tree
(autoload 'dir-tree "dir-tree"
  "Display the ROOT directory in a tree widget." t)

;; gdiff
(require 'gdiff-setup)

;; swbuff
(autoload 'swbuff-switch-to-next-buffer "swbuff"
  "Switch to the next buffer in the buffer list." t)
(autoload 'swbuff-kill-this-buffer "swbuff"
  "Kill the current buffer.
And update the status window if showing." t)

;; tabbar
(autoload 'tabbar-local-mode "tabbar" nil t)
(autoload 'tabbar-mode "tabbar" nil t)
(autoload 'tabbar-mwheel-mode "tabbar" nil t)

;; jjar
(autoload 'jjar-create "jjar" "Create a new jar file." t)
(autoload 'jjar-update "jjar" "Update an existing jar file." t)

;; jmaker
(autoload 'jmaker-generate-makefile "jmaker"
  "Generate and edit a Java Makefile in directory ROOT." t)

;; jsee
(autoload 'jsee-browse-api-doc "jsee"
  "Browse the Java API Documentation of the current Java file." t)
