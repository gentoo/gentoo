;;; lfe site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'lfe-mode "lfe-mode" nil t)
(autoload 'inferior-lfe-mode "inferior-lfe-mode" nil t)
