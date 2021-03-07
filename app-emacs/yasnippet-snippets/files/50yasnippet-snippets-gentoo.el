(eval-after-load "yasnippet"
  '(let ((snippets-dir "@SITEETC@"))
     (add-to-list 'yas-snippet-dirs snippets-dir t)
     (yas-load-directory snippets-dir t)))
