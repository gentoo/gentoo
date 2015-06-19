
;;; monotone site-lisp configuration

(add-to-list 'load-path "@SITELISP@")

(autoload 'monotone-toggle-vc-prefix-map "monotone"
  "Toggle between the default and monotone vc-maps, ARG set map." t)
(autoload 'monotone "monotone"
  "Prompt for a STRING and run monotone with the split string." t)
(autoload 'monotone-pull "monotone"
  "Pull updates from a remote server.  ARG prompts." t)
(autoload 'monotone-push "monotone"
  "Push the DB contents to a remote server.  ARG prompts." t)
(autoload 'monotone-vc-commit "monotone" "Do a commit." t)
(autoload 'monotone-vc-print-log "monotone"
  "Print the log for this buffer.  With prefix ARG the global log." t)
(autoload 'monotone-vc-diff "monotone"
  "Print the diffs for this buffer.  With prefix ARG, the global diffs." t)
(autoload 'monotone-vc-register "monotone"
  "Register this file with monotone for the next commit." t)
(autoload 'monotone-vc-status "monotone"
  "Print the status of the current branch." t)
(autoload 'monotone-grab-id "monotone"
  "Grab the id under point and put it in the kill buffer for later use." t)

(autoload 'mnav-revdb-reload "monotone-nav")
(autoload 'mnav-pick "monotone-nav"
  "Display browser to pick a monotone revision." t)
