
;;; cmt site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'cmt-mode "cmt-mode" "CMT requirements file editing mode." t)
(add-to-list 'auto-mode-alist '("requirements\\'" . cmt-mode))
