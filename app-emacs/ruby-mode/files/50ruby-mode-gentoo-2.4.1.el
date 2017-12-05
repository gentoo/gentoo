(add-to-list 'load-path "@SITELISP@")

(autoload 'ruby-mode "ruby-mode" "Major mode to edit ruby files." t)

(add-to-list 'auto-mode-alist '("Rakefile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.\\(rake\\|rb\\)\\'" . ruby-mode))
(add-to-list 'interpreter-mode-alist  '("ruby" . ruby-mode))

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process" t)
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")

(add-hook 'ruby-mode-hook 'inf-ruby-keys)
