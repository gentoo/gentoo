;; This must be executed after rng-schema-locating-files
;; is set in rng-loc (which is part of nxml-mode).
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
		"@SITEETC@/schemas.xml"))
