
;; hlint emacs integration site initialisation
(add-to-list 'load-path "@SITELISP@")
(require 'hs-lint)
(defun hlint-haskell-mode-hook ()
   (local-set-key "\C-cl" 'hs-lint))
(add-hook 'haskell-mode-hook 'hlint-haskell-mode-hook)
