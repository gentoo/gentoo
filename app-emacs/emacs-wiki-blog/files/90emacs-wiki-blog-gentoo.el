
;;; emacs-wiki-blog site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'emacs-wiki-blog-last-n-entries "emacs-wiki-blog")
(autoload 'emacs-wiki-blog-generate-calendar "emacs-wiki-blog")
(autoload 'emacs-wiki-blog-generate-archives "emacs-wiki-blog")
(autoload 'ewb-publish-rss "emacs-wiki-blog")
(autoload 'gs-latex-tag "latex2png")
(autoload 'latex2png "latex2png")
(autoload 'gs-emacs-wiki-thumbnail-tag "plog")

(eval-after-load "emacs-wiki-colors"
  '(progn
     (add-to-list 'emacs-wiki-markup-tags '("latex" t t t gs-latex-tag))
     (add-to-list 'emacs-wiki-markup-tags
		  '("thumb" t t t gs-emacs-wiki-thumbnail-tag))))

(setq gs-latex2png-scale-factor 2.5)
