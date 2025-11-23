(add-to-list 'load-path "@SITELISP@")
(autoload 'js2-imenu-extras-setup "js2-imenu-extras")
(autoload 'js2-imenu-extras-mode "js2-imenu-extras"
  "Toggle Imenu support for frameworks and structural patterns." t)
(autoload 'js2-highlight-unused-variables-mode "js2-mode"
  "Toggle highlight of unused variables." t)
(autoload 'js2-minor-mode "js2-mode"
  "Minor mode for running js2 as a background linter." t)
(autoload 'js2-mode "js2-mode"
  "Major mode for editing JavaScript code." t)
(autoload 'js2-jsx-mode "js2-mode"
  "Major mode for editing JSX code in Emacs 26 and earlier." t)
