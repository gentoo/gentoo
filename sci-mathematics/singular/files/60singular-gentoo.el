
;; site-file for sci-mathematics/singular

(add-to-list 'load-path "@SITELISP@")
(autoload 'singular "singular"
  "Start Singular using default values." t)
(autoload 'singular-other "singular"
  "Ask for arguments and start Singular." t)

(add-to-list 'auto-mode-alist '("\\.sing\\'" . c++-mode))
