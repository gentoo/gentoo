(add-to-list 'load-path "@SITELISP@")
(autoload 'color-theme-zenburn "zenburn"
  "Just some alien fruit salad to keep you in the zone." t)
(defalias 'zenburn 'color-theme-zenburn)
