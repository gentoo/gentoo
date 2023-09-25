(add-to-list 'load-path "@SITELISP@")
(autoload 'erefactor-add-current-defun "erefactor"
  "Add current defun form to `load-history'." t)
(autoload 'erefactor-change-prefix-in-buffer "erefactor"
  "Rename symbol prefix with queries." t)
(autoload 'erefactor-check-eval-mode "erefactor"
  "Display compiling warnings when \\[eval-last-sexp], \\[eval-defun]" t)
(autoload 'erefactor-eval-current-defun "erefactor"
  "Evaluate current defun and add definition to `load-history'." t)
(autoload 'erefactor-highlight-current-symbol "erefactor"
  "Highlight current symbol in this buffer." t)
(autoload 'erefactor-lint "erefactor"
  "Execuet Elint in new Emacs process." t)
(autoload 'erefactor-lint-by-emacsen "erefactor"
  "Execute Elint in new Emacs processes." t)
(autoload 'erefactor-rename-symbol-in-buffer "erefactor"
  "Rename symbol at point resolving reference local variable." t)
(autoload 'erefactor-rename-symbol-in-package "erefactor"
  "Rename symbol at point with queries." t)
