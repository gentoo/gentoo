(add-to-list 'load-path "@SITELISP@")
(autoload 'ebuild-run-mode "ebuild-run-mode"
  "Major mode for non-interactive buffers spawned by `ebuild-run-command'.")
(setq ebuild-log-buffer-mode 'ebuild-run-mode)
