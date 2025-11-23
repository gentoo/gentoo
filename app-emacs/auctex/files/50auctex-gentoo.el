;;; auctex site-lisp configuration  -*-lexical-binding:t-*-

(add-to-list 'load-path "@SITELISP@")
(require 'tex-site)

;; detect needed steps after rebuild
(setq TeX-parse-self t)
