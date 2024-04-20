(add-to-list 'load-path "@SITELISP@")
(autoload 'doxymacs-mode "doxymacs"
  "Minor mode for using/creating Doxygen documentation." t)
(autoload 'doxymacs-font-lock "doxymacs"
  "Turn on font-lock for Doxygen keywords." t)
(add-hook 'c-mode-common-hook 'doxymacs-mode)

;; optional font-lock support
;;(defun gentoo-doxymacs-font-lock-hook ()
;;  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
;;      (doxymacs-font-lock)))
;;(add-hook 'font-lock-mode-hook 'gentoo-doxymacs-font-lock-hook)
