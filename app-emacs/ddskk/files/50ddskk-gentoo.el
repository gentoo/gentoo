(add-to-list 'load-path "@SITELISP@")
(require 'skk-autoloads)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)

(setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")
