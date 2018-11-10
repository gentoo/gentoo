
;;; bicyclerepair site-lisp configuration

(add-hook
 'python-mode-hook
 (lambda ()
   (unless (fboundp 'brm-menu)
     (require 'pymacs)
     (pymacs-load "bikeemacs" "brm-")
     (brm-init))))
