(add-to-list 'load-path "@SITELISP@")
(autoload 'htmlize-buffer "htmlize"
  "Convert BUFFER to HTML, preserving colors and decorations." t)
(autoload 'htmlize-region "htmlize"
  "Convert the region to HTML, preserving colors and decorations." t)
(autoload 'htmlize-file "htmlize"
  "Load FILE, fontify it, convert it to HTML, and save the result." t)
(autoload 'htmlize-many-files "htmlize"
  "Convert FILES to HTML and save the corresponding HTML versions." t)
(autoload 'htmlize-many-files-dired "htmlize"
  "HTMLize dired-marked files." t)
