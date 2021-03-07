(add-to-list 'load-path "@SITELISP@")
;; extracted from dotemacs file distributed with the source tarball
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)
(add-to-list 'auto-mode-alist '("\\.gp\\'" . gnuplot-mode))
;;(global-set-key [(f9)] 'gnuplot-make-buffer)
