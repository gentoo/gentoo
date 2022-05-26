(add-to-list 'load-path "@SITELISP@")
(autoload 'boogie-mode "boogie-mode"
  "Major mode for editing Boogie programs." t)
(add-to-list 'auto-mode-alist '("\\.bpl\\'" . boogie-mode))
(autoload 'dafny-mode "dafny-mode"
  "Major mode for editing Dafny programs." t)
(add-to-list 'auto-mode-alist '("\\.dfy\\'" . dafny-mode))
(autoload 'z3-smt2-mode "z3-smt2-mode"
  "Major mode for editing SMT2 programs." t)
(add-to-list 'auto-mode-alist '("\\.smt2\\'" . z3-smt2-mode))
