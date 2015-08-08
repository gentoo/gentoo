(in-package #:cl-user)

#-(or cmu ccl ecl sbcl)
(let ((*compile-print* nil)
      (*compile-verbose* nil)
      #+cmu (ext:*gc-verbose* nil))
  (handler-bind ((warning #'muffle-warning))
    (load #p"@GENTOO_PORTAGE_EPREFIX@/usr/share/common-lisp/source/asdf/build/asdf.lisp"
          :print nil :verbose nil)))

#+(or cmu ccl ecl sbcl)
(require :asdf)
