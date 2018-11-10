(add-to-list 'load-path "@SITELISP@")

(autoload 'remember "remember" "Remember an arbitrary piece of data." t)
(autoload 'remember-region "remember" "Remember the data from BEG to END." t)
(autoload 'remember-clipboard "remember"
  "Remember the contents of the current clipboard." t)
(autoload 'remember-buffer "remember"
  "Remember the contents of the current buffer." t)
