(add-to-list 'load-path "@SITELISP@")
(autoload 'popwin:display-buffer "popwin"
  "Display BUFFER-OR-NAME, if possible, in a popup window, or as usual.
This function can be used as a value of `display-buffer-function'." t)
(autoload 'popwin:special-display-popup-window "popwin"
  "The `special-display-function' with a popup window.")
