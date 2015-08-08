(add-to-list 'load-path "@SITELISP@")
(autoload 'rpm-spec-mode "rpm-spec-mode"
  "Major mode for editing RPM spec files." t)
(add-to-list 'auto-mode-alist '("\\.spec\\'" . rpm-spec-mode))
