
;;; libidn site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'idna-to-ascii "idna"
  "Returns an ASCII Compatible Encoding (ACE) of STR.")
(autoload 'idna-to-unicode "idna"
  "Returns a possibly multibyte string after decoding STR.")
(autoload 'punycode-encode "punycode"
  "Returns a Punycode encoding of STR.")
(autoload 'punycode-decode "punycode"
  "Returns a possibly multibyte string which is the punycode decoding of STR.")
