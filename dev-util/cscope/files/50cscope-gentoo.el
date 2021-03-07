(add-to-list 'load-path "@SITELISP@")

(autoload 'cscope-minor-mode "xcscope")
(autoload 'cscope-display-buffer "xcscope"
  "Display the *cscope* buffer." t)
(autoload 'cscope-display-buffer-toggle "xcscope"
  "Toggle cscope-display-cscope-buffer, which corresponds to
\"Auto display *cscope* buffer\"." t)
(autoload 'cscope-next-symbol "xcscope"
  "Move to the next symbol in the *cscope* buffer." t)
(autoload 'cscope-next-file "xcscope"
  "Move to the next file in the *cscope* buffer." t)
(autoload 'cscope-prev-symbol "xcscope"
  "Move to the previous symbol in the *cscope* buffer." t)
(autoload 'cscope-prev-file "xcscope"
  "Move to the previous file in the *cscope* buffer." t)
(autoload 'cscope-pop-mark "xcscope"
  "Pop back to where cscope was last invoked." t)
(autoload 'cscope-set-initial-directory "xcscope"
  "Set the cscope-initial-directory variable." t)
(autoload 'cscope-unset-initial-directory "xcscope"
  "Unset the cscope-initial-directory variable." t)
(autoload 'cscope-find-this-symbol "xcscope"
  "Locate a symbol in source code." t)
(autoload 'cscope-find-global-definition "xcscope"
  "Find a symbol's global definition." t)
(autoload 'cscope-find-global-definition-no-prompting "xcscope"
  "Find a symbol's global definition without prompting." t)

(defun cscope:hook ()
  (cscope-minor-mode))
(add-hook 'c-mode-hook 'cscope:hook)
(add-hook 'c++-mode-hook 'cscope:hook)
(add-hook 'dired-mode-hook 'cscope:hook)
