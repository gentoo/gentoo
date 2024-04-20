;; YaTeX-mode
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

;; YaHtml-mode
(setq auto-mode-alist
      (cons (cons "\\.html$" 'yahtml-mode) auto-mode-alist))
(autoload 'yahtml-mode "yahtml" "Yet Another HTML mode" t)

;; If your Kanji code is EUC-JP, then it is better to add following
;; lines into .emacs, and it makes file encoding EUC.

(setq YaTeX-kanji-code 3)
(setq yahtml-kanji-code 3)
