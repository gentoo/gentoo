(add-to-list 'load-path "@SITELISP@")
(autoload 'meson-mode "meson-mode"
  "Major mode for editing Meson build-system files" t)
(add-to-list 'auto-mode-alist '("/meson\\(\\.build\\|_options\\.txt\\)\\'" . meson-mode))
