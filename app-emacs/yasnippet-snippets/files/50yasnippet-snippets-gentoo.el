(add-to-list 'load-path "@SITELISP@")
(autoload 'yasnippet-snippets-initialize "yasnippet-snippets"
  "Load the `yasnippet-snippets' snippets directory." t)
(eval-after-load 'yasnippet
  '(yasnippet-snippets-initialize))
