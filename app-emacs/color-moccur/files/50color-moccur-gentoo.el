(add-to-list 'load-path "@SITELISP@")
(mapc (function (lambda (x) (autoload x "color-moccur" nil t)))
      '(moccur
	dmoccur
	dired-do-moccur
	Buffer-menu-moccur
	grep-buffers
	search-buffers
	occur-by-moccur
	isearch-moccur
	moccur-grep
	moccur-grep-find))
