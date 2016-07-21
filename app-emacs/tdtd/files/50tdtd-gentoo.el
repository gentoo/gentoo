
;;; tdtd site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'dtd-mode "tdtd" "Major mode to edit DTD files." t)
(autoload 'dtd-etags "tdtd"
  "Execute etags on FILESPEC and match on DTD-specific regular expressions."
  t)
(autoload 'dtd-grep "tdtd" "Grep for PATTERN in files matching FILESPEC." t)

;; Turn on font lock when in DTD mode
(add-hook 'dtd-mode-hooks
	  'turn-on-font-lock)

(setq auto-mode-alist
      (append
       (list
	'("\\.dcl$" . dtd-mode)
	'("\\.dec$" . dtd-mode)
	'("\\.dtd$" . dtd-mode)
	'("\\.ele$" . dtd-mode)
	'("\\.ent$" . dtd-mode)
	'("\\.mod$" . dtd-mode))
       auto-mode-alist))

;; To use resize-minibuffer-mode, uncomment this and include in your .emacs:
;;(resize-minibuffer-mode)
