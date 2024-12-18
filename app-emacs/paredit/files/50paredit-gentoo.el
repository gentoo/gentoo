(add-to-list 'load-path "@SITELISP@")
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(autoload 'enable-paredit-mode "paredit" nil t)
;; some hooks: lisp-mode-hook and scheme-mode-hook are recommended
;; in the paredit source code
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'slime-mode-hook #'enable-paredit-mode)
