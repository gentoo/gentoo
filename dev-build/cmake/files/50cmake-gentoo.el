(add-to-list 'load-path "@SITELISP@")
(autoload 'cmake-mode "cmake-mode" "Major mode for editing CMake files." t)
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))
