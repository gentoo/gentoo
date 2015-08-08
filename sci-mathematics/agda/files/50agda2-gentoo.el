;;; agda site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'agda2-mode "agda2.el"
          "Major mode for Agda files" t)
(unless (assoc "\\.agda" auto-mode-alist)
  (setq auto-mode-alist
        (nconc '(("\\.agda" . agda2-mode)
                 ("\\.alfa" . agda2-mode)) auto-mode-alist)))

