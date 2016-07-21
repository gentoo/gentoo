
;; qingy site initialisation file

(add-to-list 'load-path "@SITELISP@")
(autoload 'qingy-mode "qingy-mode"
  "Major mode for editing Qingy settings and themes" t)
(add-to-list 'auto-mode-alist '("/\\(?:settings\\|theme\\)$" . qingy-mode))
