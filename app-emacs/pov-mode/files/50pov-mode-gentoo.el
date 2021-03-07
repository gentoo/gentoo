(add-to-list 'load-path "@SITELISP@")
(autoload 'pov-mode "pov-mode" "PoVray scene file mode" t)
(add-to-list 'auto-mode-alist '("\\.pov\\'" . pov-mode))
;;(add-to-list 'auto-mode-alist '("\\.inc\\'" . pov-mode))

;; Override customization variables setting various directories.
(setq pov-include-dir "/usr/share/povray/include")
(setq pov-insertmenu-location "@SITEETC@/InsertMenu")
(setq pov-icons-location "@SITEETC@/")
