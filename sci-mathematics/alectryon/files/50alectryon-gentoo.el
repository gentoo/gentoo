(add-to-list 'load-path "@SITELISP@")
(autoload 'alectryon-mode "alectryon" "Mode for Literate Coq files." t)
(add-hook 'coq-mode-hook #'alectryon-mode t)
