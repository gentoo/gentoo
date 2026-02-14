(add-to-list 'load-path "@SITELISP@")
(autoload 'autocrypt-create-account "autocrypt"
  "Create a GPG key for Autocrypt." t)
(autoload 'autocrypt-mode "autocrypt"
  "Enable Autocrypt support in current buffer." t)
(autoload 'autocrypt-gnus--install "autocrypt-gnus")
(autoload 'autocrypt-message--install "autocrypt-message")
(autoload 'autocrypt-mu4e--install "autocrypt-mu4e")
(autoload 'autocrypt-rmail--install "autocrypt-rmail")
