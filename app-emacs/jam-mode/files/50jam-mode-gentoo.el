(add-to-list 'load-path "@SITELISP@")
(autoload 'jam-mode "jam-mode" "Generic mode for Jam rules files" t)
(add-to-list
 'auto-mode-alist
 '("\\(\\.jam\\|[Jj]ambase\\|[Jj]amfile\\|[Jj]amrules\\)\\'" . jam-mode))
