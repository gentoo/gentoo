;;; dev-perl/Perl-Critic site-lisp configuration
(add-to-list 'load-path "@SITELISP@")

(autoload 'perlcritic "perlcritic" "" t)
(autoload 'perlcritic-region "perlcritic" "" t)
(autoload 'perlcritic-mode "perlcritic" "" t)

;;; auto-run for cperl-mode and perl-mode
;;
;; (eval-after-load "cperl-mode"
;;  '(add-hook 'cperl-mode-hook 'perlcritic-mode))
;; (eval-after-load "perl-mode"
;;  '(add-hook 'perl-mode-hook 'perlcritic-mode))
