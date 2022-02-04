(add-to-list 'load-path "@SITELISP@")
(autoload 'ebuild-mode "ebuild-mode"
  "Major mode for Portage .ebuild and .eclass files." t)
(autoload 'ebuild-repo-mode "ebuild-mode"
  "Minor mode for files in an ebuild repository." t)
(autoload 'ebuild-repo-mode-maybe-enable "ebuild-mode")
(autoload 'devbook-mode "devbook-mode"
  "Major mode for editing the Gentoo Devmanual." t)
(autoload 'gentoo-newsitem-mode "gentoo-newsitem-mode"
  "Major mode for Gentoo GLEP 42 news items." t)
(autoload 'glep-mode "glep-mode"
  "Major mode for Gentoo Linux Enhancement Proposals." t)

(add-to-list 'auto-mode-alist '("\\.\\(ebuild\\|eclass\\)\\'" . ebuild-mode))
(add-to-list 'auto-mode-alist '("/devmanual.*\\.xml\\'" . devbook-mode))
(add-to-list 'auto-mode-alist
	     '("/[0-9]\\{4\\}-[01][0-9]-[0-3][0-9]-.+\\.[a-z]\\{2\\}\\.txt\\'"
	       . gentoo-newsitem-mode))
(add-to-list 'auto-mode-alist '("/glep.*\\.rst\\'" . glep-mode))
(add-to-list 'auto-mode-alist
	     '("/\\(package\\.\\(mask\\|unmask\\|use\\|env\
\\|license\\|properties\\|accept_\\(keywords\\|restrict\\)\\)\
\\|\\(package\\.\\)?use.\\(stable\\.\\)?\\(force\\|mask\\)\\)\\'"
	       . conf-space-mode))
(add-to-list 'interpreter-mode-alist '("openrc-run" . sh-mode))
(add-to-list 'interpreter-mode-alist '("runscript" . sh-mode))
(add-hook 'find-file-hook #'ebuild-repo-mode-maybe-enable)
(modify-coding-system-alist 'file "\\.\\(ebuild\\|eclass\\)\\'" 'utf-8)
