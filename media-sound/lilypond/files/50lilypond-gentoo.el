
;;; lilypond site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
(add-to-list 'auto-mode-alist '("\\.i?ly\\'" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook 'turn-on-font-lock)
