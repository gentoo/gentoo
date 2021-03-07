(add-to-list 'load-path "@SITELISP@")
(autoload 'mediawiki-open "mediawiki"
  "Open a wiki page specified by NAME from the mediawiki engine" t)
(autoload 'mediawiki-site "mediawiki"
  "Set up mediawiki.el for a site." t)
(eval-after-load "mediawiki"
  '(add-to-list 'mediawiki-site-alist
		'("Gentoo" "http://wiki.gentoo.org/" "" "" "Main Page")
		nil
		(lambda (a b) (equal (car a) (car b)))))
