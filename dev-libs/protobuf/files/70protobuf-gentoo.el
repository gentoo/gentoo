(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))
(autoload 'protobuf-mode "protobuf-mode" "Google protobuf mode." t)
