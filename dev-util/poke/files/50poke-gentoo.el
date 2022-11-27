;;; poke site-lisp configuration

(autoload 'poke-ras-mode "poke-ras-mode"
  "Major mode for writing poke RAS programs." t)
(autoload 'poke-map-mode "poke-map-mode"
  "Major mode for writing poke map-files." t)

(add-to-list 'auto-mode-alist '(".*\\.pks" . poke-ras-mode))
(add-to-list 'auto-mode-alist '(".*\\.map" . poke-map-mode))
