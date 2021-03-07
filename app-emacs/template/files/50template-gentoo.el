(add-to-list 'load-path "@SITELISP@")
(autoload 'template-single-comment "template"
  "Decorate the comment in the current line with dashes and alike." t)
(autoload 'template-block-comment "template"
  "Decorate the current block of comment-only lines with dashes and alike." t)
(autoload 'template-update-header "template"
  "Replace old file name in header with current file name." t)
(autoload 'template-expand-template "template"
  "Expand template file TEMPLATE and insert result in current buffer." t)
(autoload 'template-new-file "template"
  "Open a new file FILE by using a TEMPLATE." t)
(autoload 'template-initialize "template"
  "Initialized package template.  See variable `template-initialize'." t)

(setq template-default-directories
      (list (if (and (not (file-directory-p "~/.templates/"))
		     (file-directory-p "~/lib/templates"))
		(expand-file-name "~/lib/templates/")
	      (expand-file-name "~/.templates/"))
	    "@SITEETC@/templates"))
