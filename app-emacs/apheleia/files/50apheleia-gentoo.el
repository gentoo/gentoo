(add-to-list 'load-path "@SITELISP@")
(autoload 'apheleia-format-buffer "apheleia"
  "Run code formatter asynchronously on current buffer, preserving point." t)
(autoload 'apheleia-global-mode "apheleia"
  "Global minor mode for reformatting code on save without moving point." t)
(autoload 'apheleia-mode "apheleia"
  "Minor mode for reformatting code on save without moving point." t)
