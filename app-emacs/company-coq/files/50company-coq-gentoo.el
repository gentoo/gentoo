(add-to-list 'load-path "@SITELISP@")
(autoload 'company-coq-mode "company-coq"
  "Collection of extensions for Proof General's Coq mode" t)
(add-hook 'coq-mode 'company-coq-mode)
