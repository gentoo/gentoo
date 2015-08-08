(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?\\'" . caml-mode))
(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)
(autoload 'camldebug "camldebug"
  "Run camldebug on program FILE in buffer *camldebug-FILE*." t)
(autoload 'inferior-caml-mode-font-hook "caml-font")

(eval-after-load "caml" '(require 'caml-font))
(add-hook 'inferior-caml-mode-hooks 'inferior-caml-mode-font-hook)
