(add-to-list 'load-path "@SITELISP@")
(autoload 'swift-mode "swift-mode"
  "Major mode for editing Swift code." t)
(add-to-list 'auto-mode-alist '("\\.swift\\'" . swift-mode))
