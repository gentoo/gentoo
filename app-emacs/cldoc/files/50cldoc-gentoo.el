(add-to-list 'load-path "@SITELISP@")

(autoload 'cldoc-mode "cldoc" nil t)
(autoload 'turn-on-cldoc-mode "cldoc" nil t)
(add-hook 'lisp-mode-hook 'turn-on-cldoc-mode)

(add-hook 'slime-repl-mode-hook
          #'(lambda ()
              (turn-on-cldoc-mode)
              (define-key slime-repl-mode-map " " nil)))
(add-hook 'slime-mode-hook
          #'(lambda () (define-key slime-mode-map " " nil)))
(setq slime-use-autodoc-mode nil)
