
;;; geomview site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'gvcl-mode "gvcl-mode"
  "Major mode for editing Geomview Command Language files." t)
(add-to-list 'auto-mode-alist '("\\.gcl\\'" . gvcl-mode))
