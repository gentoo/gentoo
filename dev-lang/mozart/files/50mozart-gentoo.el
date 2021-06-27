;;; mozart site-lisp configuration

(or (getenv "OZHOME")
    (setenv "OZHOME" "/usr"))
(add-to-list 'load-path "@SITELISP@")
(autoload 'run-oz' "oz" "Start Mozart as a sub-process" t)
(autoload 'oz-mode "oz" "Major mode for editing Oz code." t)
(autoload 'oz-gump-mode "oz"
  "Major mode for editing Oz code with embedded Gump specifications." t)
(autoload 'ozm-mode "mozart" "Major mode for displaying Oz machine code." t)
(add-to-list 'auto-mode-alist '("\\.oz$" . oz-mode))
(add-to-list 'auto-mode-alist '("\\.ozg$" . oz-gump-mode))
(add-to-list 'auto-mode-alist '("\\.ozm$" . ozm-mode))
