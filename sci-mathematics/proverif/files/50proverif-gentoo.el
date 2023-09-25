(add-to-list 'load-path "@SITELISP@")
(autoload 'proverif-horn-mode "proverif"
  "Major mode for editing ProVerif code." t)
(autoload 'proverif-horntype-mode "proverif"
  "Major mode for editing ProVerif code." t)
(autoload 'proverif-pi-mode "proverif"
  "Major mode for editing ProVerif code." t)
(autoload 'proverif-pv-mode "proverif"
  "Major mode for editing ProVerif code." t)
(add-to-list 'auto-mode-alist '("\\.horn$" . proverif-horn-mode))
(add-to-list 'auto-mode-alist '("\\.horntype$" . proverif-horntype-mode))
(add-to-list 'auto-mode-alist '("\\.pi$" . proverif-pi-mode))
(add-to-list 'auto-mode-alist '("\\.pv[l]?$" . proverif-pv-mode))
