
;; site-init for media-gfx/asymptote

(add-to-list 'load-path "@SITELISP@")

(autoload 'asy-mode "asy-mode" "Asymptote major mode." t)
(autoload 'lasy-mode "asy-mode" "Hybrid Asymptote/Latex major mode." t)
(autoload 'asy-insinuate-latex "asy-mode" "Asymptote insinuate LaTeX." t)
(add-to-list 'auto-mode-alist '("\\.asy$" . asy-mode))
