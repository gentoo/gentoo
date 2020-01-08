(add-to-list 'load-path "@SITELISP@")

(autoload 'ledger-mode "ledger-mode" "A mode for editing ledger data files." t)
(autoload 'ledger-flymake-enable "ledger-flymake" "\
Enable `flymake-mode' in `ledger-mode' buffers.

Don't enable flymake if flycheck is on and flycheck-ledger is
available." nil)

(add-to-list 'auto-mode-alist '("\\.ledger\\'" . ledger-mode))
