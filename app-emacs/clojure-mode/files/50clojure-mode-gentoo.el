(add-to-list 'load-path "@SITELISP@")
(autoload 'clojure-mode "clojure-mode"
  "Major mode for editing Clojure code." t)
(add-to-list 'auto-mode-alist '("\\(?:build\\|profile\\)\\.boot\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.\\(clj\\|cljd\\|dtm\\|edn\\)\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljc\\'" . clojurec-mode))
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojurescript-mode))
(add-to-list 'interpreter-mode-alist '("bb" . clojure-mode))
