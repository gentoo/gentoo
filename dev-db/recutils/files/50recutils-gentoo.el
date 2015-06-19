
;; site-init for dev-db/recutils

(add-to-list 'load-path "@SITELISP@")
(autoload 'rec-mode "rec-mode" "A mode for viewing/editing rec files." t)
(add-to-list 'auto-mode-alist '("\\.rec$" . rec-mode))
