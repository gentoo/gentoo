# Copy this file to additional_environment.rb and add any statements
# that need to be passed to the Rails::Initializer.  `config` is
# available in this context.

# Place log-files to /var/log/redmine
config.logger = Logger.new(Rails.root.join("/var/log/redmine",Rails.env + ".log"), 0, 10485760)
config.log_level= :info
