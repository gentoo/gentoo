(add-to-list 'load-path "@SITELISP@")
(autoload 'mldonkey "mldonkey" "Run the MlDonkey interface." t)

(setq mldonkey-vd-filename-filters
      '(mldonkey-vd-filename-remove-p20
	mldonkey-vd-filename-remove-trailing-ws))

(setq mldonkey-vd-sort-functions
      '((not mldonkey-vd-sort-dl-state)
        (not mldonkey-vd-sort-dl-percent)))

(setq mldonkey-vd-sort-fin-functions
      '(mldonkey-vd-sort-dl-number))

(add-hook 'mldonkey-pause-hook 'mldonkey-vd)
(add-hook 'mldonkey-resume-hook 'mldonkey-vd)
(add-hook 'mldonkey-commit-hook 'mldonkey-vd)
(add-hook 'mldonkey-recover-temp-hook 'mldonkey-vd)
