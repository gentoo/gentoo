(add-to-list 'load-path "@SITELISP@")
(autoload 'macrostep-mode "macrostep"
  "Minor mode for inline expansion of macros in Emacs Lisp source buffers." t)
(autoload 'macrostep-expand "macrostep"
  "Expand the macro form following point by one step." t)
(autoload 'macrostep-c-mode-hook "macrostep-c"
  nil t)
