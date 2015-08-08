
;;; librep site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'rep-debugger "rep-debugger"
  "Run the rep debugger on program FILE in buffer *gud-FILE*." t)
