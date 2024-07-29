(add-to-list 'load-path "@SITELISP@")
(autoload 'pinentry-start "pinentry"
  "Start a Pinentry service.

Once the environment is properly set, subsequent invocations of
the gpg command will interact with Emacs for passphrase input.

If the optional QUIET argument is non-nil, messages at startup
will not be shown.

\(fn &optional QUIET)" t)
