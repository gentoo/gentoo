;;; poke-mode site configuration
(add-to-list 'load-path "@SITELISP@")

(autoload 'poke-mode "poke-mode"
  "Poke PK (pickle) editing mode." t)

(add-to-list 'auto-mode-alist '(".*\\.pk" . poke-mode))
