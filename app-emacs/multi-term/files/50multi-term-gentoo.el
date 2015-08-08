(add-to-list 'load-path "@SITELISP@")
(autoload 'multi-term "multi-term"
  "Create new term buffer.
Will prompt you shell name when you type `C-u' before this command." t)
(autoload 'multi-term-dedicated-open "multi-term"
  "Open dedicated `multi-term' window.
Will prompt you shell name when you type `C-u' before this command." t)
