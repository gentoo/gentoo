;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-

(defpackage #:swank-system
  (:use #:common-lisp #:asdf))

(in-package #:swank-system)

(defun load-user-init-file ()
  "Load the user init file, return NIL if it does not exist."
  (load (merge-pathnames (user-homedir-pathname)
                         (make-pathname :name ".swank" :type "lisp"))
        :if-does-not-exist nil))

(defun load-site-init-file ()
  (load (make-pathname :name "site-init" :type "lisp"
                       :defaults (truename
                                  (asdf:system-definition-pathname
                                   (asdf:find-system :swank))))
        :if-does-not-exist nil))

(defclass no-load-file (cl-source-file) ())

(defmethod perform ((op load-op) (c no-load-file)) nil)

(defmacro define-swank-system (sysdep-files)
  `(defsystem :swank
     :description "Swank is the Common Lisp back-end to SLIME"
     :serial t
     :components ((:file "swank-backend")
                  (:file "nregex")
                  ,@(mapcar #'(lambda (component)
                                (if (atom component)
                                    (list :file component)
                                    component))
                            sysdep-files)
                  (:file "swank-match")
                  (:file "swank-rpc")
                  (:file "swank")
                  (:module "contrib"
                   :components ((:no-load-file "swank-c-p-c")
                                (:no-load-file "swank-arglists"
                                 :depends-on ("swank-c-p-c"))
                                (:no-load-file "swank-asdf")
                                (:no-load-file "swank-clipboard")
                                (:no-load-file "swank-fancy-inspector")
                                (:no-load-file "swank-fuzzy"
                                 :depends-on ("swank-c-p-c"))
                                (:no-load-file "swank-hyperdoc")
                                (:no-load-file "swank-indentation")
                                (:no-load-file "swank-listener-hooks")
                                (:no-load-file "swank-media")
                                (:no-load-file "swank-motd")
                                (:no-load-file "swank-package-fu")
                                (:no-load-file "swank-presentations")
                                (:no-load-file "swank-presentation-streams"
                                 :depends-on ("swank-presentations"))
                                (:no-load-file "swank-sbcl-exts"
                                 :depends-on ("swank-arglists"))
                                (:no-load-file "swank-snapshot")
                                (:no-load-file "swank-sprof"))))
     :depends-on (#+sbcl sb-bsd-sockets)
     :perform (load-op :after (op swank)
                       (load-site-init-file)
                       (load-user-init-file))))

#+(or cmu scl sbcl openmcl clozurecl lispworks allegro clisp armedbear cormanlisp ecl)
(define-swank-system
  #+cmu (swank-source-path-parser swank-source-file-cache swank-cmucl)
  #+scl (swank-source-path-parser swank-source-file-cache swank-scl)
  #+sbcl (swank-source-path-parser swank-source-file-cache swank-sbcl swank-gray)
  #+(or openmcl clozurecl) (metering
                            #.(if (and (find-package "CCL")
                                       (fboundp (intern "COMPUTE-APPLICABLE-METHODS-USING-CLASSES" "CCL")))
                                  'swank-ccl
                                  'swank-openmcl)
                            swank-gray)
  #+lispworks (swank-lispworks swank-gray)
  #+allegro (swank-allegro swank-gray)
  #+clisp (xref metering swank-clisp swank-gray)
  #+armedbear (swank-abcl)
  #+cormanlisp (swank-corman swank-gray)
  #+ecl (swank-source-path-parser swank-source-file-cache swank-ecl swank-gray))

#-(or cmu scl sbcl openmcl clozurecl lispworks allegro clisp armedbear cormanlisp ecl)
(error "Your CL implementation is not supported !")

(defpackage #:swank-loader
  (:use #:common-lisp)
  (:export #:*source-directory*))

(in-package #:swank-loader)

(defparameter *source-directory*
  (asdf:component-pathname (asdf:find-system :swank)))

;; (funcall (intern (string :warn-unimplemented-interfaces) :swank-backend))

;; swank.asd ends here
