(add-to-list 'load-path "@SITELISP@")
(autoload 'webpaste-paste-region "webpaste"
  "Paste selected region to some paste service." t)
(autoload 'webpaste-paste-buffer "webpaste"
  "Paste current buffer to some paste service." t)
(autoload 'webpaste-paste-buffer-or-region "webpaste"
  "Paste current buffer or selected region to some paste service." t)
