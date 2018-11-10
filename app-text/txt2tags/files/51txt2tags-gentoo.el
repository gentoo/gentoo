
;;; txt2tags site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload  't2t-mode "txt2tags-mode" "Major mode for editing Txt2Tags files" t)
(add-to-list 'auto-mode-alist '("\\.t2t\\'" . t2t-mode))
