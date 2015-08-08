(add-to-list 'load-path "@SITELISP@")
(require 'planner-autoloads)
(setq remember-handler-functions '(remember-planner-append))
(defvaralias 'remember-annotation-functions 'planner-annotation-functions)
