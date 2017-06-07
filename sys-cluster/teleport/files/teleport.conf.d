# /etc/conf.d/teleport: config file for /etc/init.d/teleport

# Where is your teleport.yaml file stored?
TELEPORT_CONFDIR="/etc/teleport"

# Any random options you want to pass to teleport.
TELEPORT_OPTS=""

# Pid file to use (needs to be absolute path).
#TELEPORT_PIDFILE="/var/run/teleport.pid"

# Path to log file
#TELEPORT_LOGFILE="/var/log/teleport.log"

# Startup dependency
# Un-comment when using etcd storage backend
#rc_need="etcd"
