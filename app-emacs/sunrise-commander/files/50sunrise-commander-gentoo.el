(add-to-list 'load-path "@SITELISP@")
(autoload 'sunrise-toggle "sunrise"
  "Show or hide the Sunrise Commander." t)
(defalias 'sunrise 'sunrise-toggle)
