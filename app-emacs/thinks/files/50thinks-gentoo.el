(add-to-list 'load-path "@SITELISP@")

(autoload (quote thinks) "thinks" "\
Insert TEXT wrapped in a think bubble.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you.

\(fn TEXT)" t nil)

(autoload (quote thinks-region) "thinks" "\
Bubble wrap region bounding START and END.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you.

\(fn START END)" t nil)

(autoload (quote thinks-yank) "thinks" "\
Do a `yank' and bubble wrap the yanked text.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you.

\(fn)" t nil)

(autoload (quote thinks-maybe-region) "thinks" "\
If region is active, bubble wrap region bounding START and END.
If not, query for text to insert in bubble.

\(fn)" t nil)
