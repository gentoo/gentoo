(add-to-list 'load-path "@SITELISP@")
(autoload 'dockerfile-mode "dockerfile-mode"
  "A major mode to edit Dockerfiles." t)
(add-to-list 'auto-mode-alist '("/Dockerfile\\(?:\\.[^/\\]*\\)?\\'" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("\\.dockerfile\\'" . dockerfile-mode))
