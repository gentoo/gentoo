(add-to-list 'load-path "@SITELISP@")
(add-to-list 'load-path "@EMACSMODULES@")
(defvar libgit--build-dir "@EMACSMODULES@")
(autoload 'libgit-load "libegit2" "Load the `libegit2` dynamic module." t)
