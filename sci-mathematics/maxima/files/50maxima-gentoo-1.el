(add-to-list 'load-path "@SITELISP@")
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'maxima "maxima" "Maxima interactive" t)
(autoload 'dbl "dbl" "Make a debugger to run lisp, maxima and or gdb in" t)
(add-to-list 'auto-mode-alist '("\\.ma?[cx]\\'" . maxima-mode))

;; emaxima mode
(autoload 'emaxima-mode "emaxima" "EMaxima" t)
(add-hook 'emaxima-mode-hook 'emaxima-mark-file-as-emaxima)

;; imaxima
(autoload 'imaxima "imaxima" "Image support for Maxima." t)
(autoload 'imath-mode "imath" "Interactive Math minor mode." t)
