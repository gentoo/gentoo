(add-to-list 'load-path "@SITELISP@")
(autoload 'vue-mode "vue-mode"
  "Major mode for vue component based on mmm-mode" t)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
