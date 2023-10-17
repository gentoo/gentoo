(add-to-list 'load-path "@SITELISP@")
(autoload 'git-timemachine-toggle "git-timemachine.el"
  "Toggle git timemachine mode." t)
(autoload 'git-timemachine "git-timemachine.el"
  "Enable git timemachine for file of current buffer." t)
(autoload 'git-timemachine-switch-branch "git-timemachine.el"
  "Enable git timemachine for current buffer, switching to GIT-BRANCH." t)
