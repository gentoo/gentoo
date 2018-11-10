
;;; site-lisp configuration for ratpoison

(add-to-list 'load-path "@SITELISP@")

(autoload 'ratpoisonrc-mode "ratpoison" "Mode for ratpoison configuration files." t)
(autoload 'ratpoison-command "ratpoison" "Run a ratpoison command." t)
(autoload 'ratpoison-command-on-region "ratpoison" "Run a ratpoison command contained in the region." t)
(autoload 'ratpoison-info "ratpoison" "Call up the ratpoison info page." t)
(autoload 'ratpoison-command-info "ratpoison" "Call up the info page listing the ratpoison commands." t)