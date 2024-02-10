(add-to-list 'load-path "@SITELISP@")
(autoload 'bnf-mode "bnf-mode"
  "A major mode for editing BNF grammars." t)
(add-to-list 'auto-mode-alist '("\\.bnf\\'" . bnf-mode))
