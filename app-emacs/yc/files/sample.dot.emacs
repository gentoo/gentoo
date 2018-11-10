;;;; -*- mode: lisp-interaction; syntax: elisp; coding: iso-2022-7bit -*-

;;;; Configuration for yc
(setq yc-server-host "unix")
;If you use inet socket service, enable the following line.
;(setq yc-server-host "localhost")
(setq yc-use-color t)
(if (eq window-system 'x)
    (setq yc-use-fence nil)
  (setq yc-use-fence t))
(load "yc")
(global-yc-mode 1)
