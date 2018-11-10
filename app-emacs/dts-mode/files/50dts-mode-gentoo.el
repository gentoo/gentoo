(add-to-list 'load-path "@SITELISP@")
(autoload 'dts-mode "dts-mode" "Major mode for editing Devicetrees" t)

;; Separate entries in dts-mode.el itself, don't merge them into a single one.
(add-to-list 'auto-mode-alist '("\\.dts\\'" . dts-mode))
(add-to-list 'auto-mode-alist '("\\.dtsi\\'" . dts-mode))
