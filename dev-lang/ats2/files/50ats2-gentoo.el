(add-to-list 'load-path "@SITELISP@")
(autoload 'ats-mode "@SITELISP@/ats2-mode.el"
  "Major mode to edit ATS2 source code." t)
(add-to-list 'auto-mode-alist '("\\.\\(s\\|d\\|h\\)ats\\'" . ats-mode))
