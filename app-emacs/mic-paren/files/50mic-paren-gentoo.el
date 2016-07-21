(add-to-list 'load-path "@SITELISP@")
(autoload 'paren-activate "mic-paren"
  "Activates mic-paren parenthesis highlighting." t)
(autoload 'paren-deactivate "mic-paren"
  "Deactivates mic-paren parenthesis highlighting" t)
(autoload 'paren-toggle-matching-paired-delimiter "mic-paren" nil t)
(autoload 'paren-toggle-matching-quoted-paren "mic-paren" nil t)
(autoload 'paren-toggle-open-paren-context "mic-paren" nil t)
(autoload 'paren-forward-sexp "mic-paren" nil t)
(autoload 'paren-backward-sexp "mic-paren" nil t)
