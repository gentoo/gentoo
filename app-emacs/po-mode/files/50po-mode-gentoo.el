(add-to-list 'load-path "@SITELISP@")
(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)
(or (fboundp 'po-find-file-coding-system)
    (autoload 'po-find-file-coding-system "po-compat"))

(add-to-list 'auto-mode-alist '("\\.po\\'\\|\\.po\\." . po-mode))
(modify-coding-system-alist 'file "\\.po\\'\\|\\.po\\."
			    'po-find-file-coding-system)
