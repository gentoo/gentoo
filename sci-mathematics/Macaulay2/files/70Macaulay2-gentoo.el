;; sci-mathematics/Macaulay2 init file

(add-to-list 'load-path "/usr/share/emacs/site-lisp/Macaulay2")

(defvar M2-exe "/usr/bin/M2" "*The default Macaulay2 executable name.")
(autoload 'M2 "M2.el" "Run Macaulay 2 in a buffer." t)
(autoload 'Macaulay2 "M2" "Run Macaulay 2 in a buffer, non-interactive." t)
(autoload 'M2-mode "M2" "Macaulay 2 editing mode" t)
(autoload 'm2-mode "M2" "Macaulay 2 editing mode, name in lower case" t)
(autoload 'm2-comint-mode "M2" "Macaulay 2 command interpreter mode, name in lower case" t)
(setq auto-mode-alist (append auto-mode-alist '(("\\.m2$" . M2-mode))))