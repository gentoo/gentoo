(add-to-list 'load-path "@SITELISP@")
(autoload 'ansi-format-encode "tty-format")
(autoload 'ansi-format-decode "tty-format")
(autoload 'backspace-overstrike-encode "tty-format")
(autoload 'backspace-overstrike-decode "tty-format")
(autoload 'tty-format-guess "tty-format")

(add-to-list 'format-alist
	     '(ansi-colors
	       "ANSI SGR escape sequence colours and fonts."
	       nil
	       ansi-format-decode ansi-format-encode t nil))

(add-to-list 'format-alist
	     '(backspace-overstrike
	       "Backspace overstriking for bold and underline."
	       nil
	       backspace-overstrike-decode backspace-overstrike-encode t nil))

(custom-add-option 'find-file-hook 'tty-format-guess)
