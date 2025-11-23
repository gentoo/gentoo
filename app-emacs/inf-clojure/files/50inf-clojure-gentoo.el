(add-to-list 'load-path "@SITELISP@")
(autoload 'inf-clojure "inf-clojure"
  "Run an inferior Clojure process" t)
(autoload 'inf-clojure-minor-mode "inf-clojure"
  "Minor mode for interacting with the inferior Clojure process buffer." t)
(add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)
