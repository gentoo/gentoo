(add-to-list 'load-path "@SITELISP@")

(autoload 'python-mode "python-mode" "Major mode for editing Python files." t)
(autoload 'jython-mode "python-mode" "Major mode for editing Jython files." t)
(autoload 'py-shell "python-mode"
  "Start an interactive Python interpreter in another window." t)

(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pyx$" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-to-list 'interpreter-mode-alist '("jython" . jython-mode))
