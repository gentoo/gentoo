
;;; dev-vcs/git site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'git-status "git" "Entry point into git-status mode." t)
;;(autoload 'git-blame-mode "git-blame"
;;  "Minor mode for incremental blame for Git." t)

;; GNU Emacs >=22.2 already includes vc-git.el.
;; Enable the following only if Emacs has no GIT support.
(unless (fboundp 'vc-git-registered)
  (add-to-list 'load-path "@SITELISP@/compat")
  (add-to-list 'vc-handled-backends 'GIT))
