;;; lsp-mode site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'lsp-completion-at-point "lsp-completion" "Get lsp completions." t)
(autoload 'lsp-completion--enable "lsp-completion" "Enable LSP completion support.")
(autoload 'lsp-completion-mode "lsp-completion" "Toggle LSP completion support." t)

(autoload 'lsp-diagnostics--enable "lsp-diagnostics" "Enable LSP checker support.")
(autoload 'lsp-diagnostics-mode "lsp-diagnostics" "Toggle LSP diagnostics integration." t)

(autoload 'lsp-dired-mode "lsp-dired" "Display `lsp-mode' icons for each file in a dired buffer." t)

(autoload 'lsp-headerline--enable-breadcrumb "lsp-headerline" "Enable breadcrumb on headerline.")
(autoload 'lsp-headerline-breadcrumb-mode "lsp-headerline" "Toggle breadcrumb on headerline." t)

(autoload 'lsp-ido-workspace-symbol "lsp-ido" "`ido' for lsp workspace/symbol." t)

(autoload 'lsp-iedit-highlights "lsp-iedit" "Start an `iedit' operation on the documentHighlights at point." t)

(autoload 'lsp-lens--enable "lsp-lens" "Enable lens mode.")
(autoload 'lsp-lens-show "lsp-lens" "Display lenses in the buffer." t)
(autoload 'lsp-lens-mode "lsp-lens" "Toggle code-lens overlays." t)

(autoload 'lsp "lsp-mode" "Entry point for the server startup." t)
(autoload 'lsp-deferred "lsp-mode" "Entry point that defers server startup until buffer is visible." t)

(autoload 'lsp-modeline-code-actions-mode "lsp-modeline" "Toggle code actions on modeline." t)
(autoload 'lsp-modeline-diagnostics-mode "lsp-modeline" "Toggle diagnostics modeline." t)
(autoload 'lsp-modeline-workspace-status-mode "lsp-modeline" "Toggle workspace status on modeline." t)

(autoload 'lsp--semantic-tokens-initialize-buffer "lsp-semantic-tokens" "Initialize the buffer for semantic tokens.")
(autoload 'lsp--semantic-tokens-initialize-workspace "lsp-semantic-tokens" "Initialize semantic tokens for WORKSPACE.")
(autoload 'lsp-semantic-tokens--enable "lsp-semantic-tokens" "Enable semantic tokens mode.")
(autoload 'lsp-semantic-tokens-mode "lsp-semantic-tokens" "Toggle semantic-tokens support.")
