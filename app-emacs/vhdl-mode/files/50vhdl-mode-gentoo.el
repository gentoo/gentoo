(add-to-list 'load-path "@SITELISP@")
(autoload 'vhdl-mode "vhdl-mode" "VHDL Mode" t)
(add-to-list 'auto-mode-alist '("\\.vhdl?\\'" . vhdl-mode))
