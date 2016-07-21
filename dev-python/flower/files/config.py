# Configuration file for the Celery Flower service. Standard Celery
# configuration settings can be overridden in the configuration file. See the
# Celery Configuration documentation for a complete listing of all available
# settings, and their default values.


# URL for the broker used by Celery.
# BROKER_URL = 'amqp://guest:guest@localhost:5672//'


# Run the HTTP service on the given address.
#
# addess = localhost


# Run the HTTP server on the given port.
#
# port = 5555


# Enables Google OpenID authentication. `auth` is a regexp of emails to grant
# access. For more info see google-openid.
#
# auth = None


# Refresh dashboards automatically.
#
# auto_refresh = True


# Enables HTTP Basic authentication. `basic_auth` is a comma separated list of
# `username:password`. If configured, any client trying to access this Flower
# instance will be prompted to provide the credentials specified in this
# argument.
#
# basic_auth = None


# Flower can use the RabbitMQ Management Plugin to get info about queues.
# `broker_api` is a URL of a RabbitMQ HTTP API including user credentials.
#
# broker_api = http://username:password@rabbitmq-server-name:15672/api


# A path to ca_certs file. The ca_certs file contains a set of concatenated
# "certification authority" certificates, which are used to validate
# certificates passed from the other end of the connection.
#
# ca_certs = None


# A path to an x509 certificate file.
#
# certfile = None


# A path to the private key for `certfile`.
#
# keyfile = None


# Enable debug mode.
#
# debug = False


# Periodically enable Celery events by using `enable_events` command
#
# enable_events = True


# Modifies the default task formatting. `format_task` should be a function
# that accepts a task object and returns a modified version. This is useful
# when filtering out sensitive information.
#
# format_task = None


# Sets worker inspect timeout in milliseconds.
#
# inspect_timeout = 10000


# Maximum number of tasks to keep in memory.
#
# max_tasks = 10000


# Show time relative to the refresh time.
#
# natural_time = True


# Enable persistent mode. If the persistent mode is enabled, Flower saves the
# current state and reloads on restart.
#
# persistent = False


# A path to a database file to use if persistent mode is enabled.
#
# db = flower


# Enable support of `X-Real-Ip` and `X-Scheme` headers
#
# xheaders = False


# Specifies list of comma-delimited columns on the /tasks/ page. Order of slugs
# in the option is unrelated to order of columns on the page. Available slugs
# include: name, uuid, state, args, kwargs, result, received, started, runtime.
#
# tasks_columns = None
