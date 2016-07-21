(add-to-list 'load-path "@SITELISP@")
(autoload 'javascript-mode "javascript"
  "Major mode for editing JavaScript source text." t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
