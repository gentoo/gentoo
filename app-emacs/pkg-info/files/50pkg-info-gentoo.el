;;; pkg-info site-lisp configuration
(add-to-list 'load-path "@SITELISP@")
(autoload 'pkg-info-library-original-version "pkg-info" nil t)
(autoload 'pkg-info-library-version "pkg-info" nil t)
(autoload 'pkg-info-defining-library-original-version "pkg-info" nil t)
(autoload 'pkg-info-defining-library-version "pkg-info" nil t)
(autoload 'pkg-info-package-version "pkg-info" nil t)
(autoload 'pkg-info-version-info "pkg-info" nil t)
