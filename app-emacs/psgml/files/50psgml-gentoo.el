(add-to-list 'load-path "@SITELISP@")
(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
(setq sgml-catalog-files '("CATALOG" "/etc/sgml/catalog"))
(setq sgml-display-char-list-filename
      "@SITEETC@/iso88591.map")
