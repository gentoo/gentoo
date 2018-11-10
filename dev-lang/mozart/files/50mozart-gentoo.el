
;;; mozart site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'oz-mode "oz" "Major mode for editing Oz code." t)
(autoload 'oz-gump-mode "oz"
  "Major mode for editing Oz code with embedded Gump specifications." t)
(autoload 'ozm-mode "mozart" "Major mode for displaying Oz machine code." t)
(add-to-list 'auto-mode-alist '("\\.oz$" . oz-mode))
(add-to-list 'auto-mode-alist '("\\.ozg$" . oz-gump-mode))
(add-to-list 'auto-mode-alist '("\\.ozm$" . ozm-mode))
