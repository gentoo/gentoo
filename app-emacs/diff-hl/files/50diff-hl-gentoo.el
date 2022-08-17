(add-to-list 'load-path "@SITELISP@")
(autoload 'diff-hl-mode "diff-hl"
  "Toggle VC diff highlighting." t)
(autoload 'diff-hl-set-reference-rev "diff-hl"
  "Set the reference revision globally to REV." t)
(autoload 'diff-hl-reset-reference-rev "diff-hl"
  "Reset the reference revision globally to the most recent one." t)
(autoload 'global-diff-hl-mode "diff-hl"
  "Toggle Diff-Hl mode in all buffers." t)
(autoload 'diff-hl-amend-mode "diff-hl-amend"
  "Show changes against the second-last revision in `diff-hl-mode'." t)
(autoload 'global-diff-hl-amend-mode "diff-hl-amend"
  "Toggle Diff-Hl-Amend mode in all buffers." t)
(autoload 'diff-hl-dired-mode "diff-hl-dired"
  "Toggle VC diff highlighting on the side of a Dired window." t)
(autoload 'diff-hl-flydiff-mode "diff-hl-flydiff"
  "Perform highlighting on-the-fly." t)
(autoload 'diff-hl-inline-popup-hide "diff-hl-inline-popup"
  "Hide the current inline popup." t)
(autoload 'diff-hl-margin-mode "diff-hl-margin"
  "Toggle displaying `diff-hl-mode' highlights on the margin." t)
(autoload 'diff-hl-margin-local-mode "diff-hl-margin"
  "Toggle displaying `diff-hl-mode' highlights on the margin locally." t)
(autoload 'diff-hl-show-hunk-previous "diff-hl-show-hunk"
  "Go to previous hunk/change and show it." t)
(autoload 'diff-hl-show-hunk-next "diff-hl-show-hunk"
  "Go to next hunk/change and show it." t)
(autoload 'diff-hl-show-hunk "diff-hl-show-hunk"
  "Show the VC diff hunk at point." t)
(autoload 'diff-hl-show-hunk-mouse-mode "diff-hl-show-hunk"
  "Enables the margin and fringe to show a posframe/popup with vc diffs when clicked." t)
(autoload 'global-diff-hl-show-hunk-mouse-mode "diff-hl-show-hunk"
  "Toggle Diff-Hl-Show-Hunk-Mouse mode in all buffers." t)
