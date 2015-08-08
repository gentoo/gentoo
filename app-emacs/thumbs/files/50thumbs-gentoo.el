(add-to-list 'load-path "@SITELISP@")
(autoload 'thumbs-find-thumb "thumbs" "Display the thumbnail for IMG." t)
(autoload 'thumbs-show-all-from-dir "thumbs"
  "Make a preview buffer for all images in DIR." t)
(autoload 'thumbs-dired-show-marked "thumbs"
  "In Dired, make a thumbs buffer with all marked files." t)
(autoload 'thumbs-dired-show-all "thumbs"
  "In dired, make a thumbs buffer with all files in current directory." t)
(defalias 'thumbs 'thumbs-show-all-from-dir)
(autoload 'thumbs-dired-setroot "thumbs"
  "In dired, Call the setroot program on the image at point." t)
