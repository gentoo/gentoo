(add-to-list 'load-path "@SITELISP@")
(setq gnuserv-program "/usr/libexec/emacs/gnuserv")
;; necessary for FSF GNU Emacs only
(autoload 'gnuserv-start "gnuserv-compat"
  "Allow this Emacs process to be a server for client processes." t)
