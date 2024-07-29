(add-to-list 'load-path "@SITELISP@")
(autoload 'lua-mode "lua-mode" "Mode for editing Lua scripts" t)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
(setq lua-default-application "/usr/bin/lua")
