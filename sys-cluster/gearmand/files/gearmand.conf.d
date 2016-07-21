# /etc/conf.d/gearmand: config file for /etc/init.d/gearmand

# Persistent queue store
# The following queue stores are available:
# drizzle|memcache|mysql|postgre|sqlite|tokyocabinet|none
# If you do not wish to use persistent queues, leave this option commented out.
# Note that persistent queue mechanisms are mutally exclusive.
#PERSISTENT=""

# Persistent queue settings for drizzle, mysql and postgre
#PERSISTENT_SOCKET=""
#PERSISTENT_HOST=""
#PERSISTENT_PORT=""
#PERSISTENT_USER=""
#PERSISTENT_PASS=""
#PERSISTENT_DB=""
#PERSISTENT_TABLE=""

# Persistent queue settings for sqlite
#PERSISTENT_FILE=""

# Persistent queue settings for memcache
#PERSISTENT_SERVERLIST=""

# General settings
#
# -j, --job-retries=RETRIES   Number of attempts to run the job before the job
#                             server removes it. Thisis helpful to ensure a bad
#                             job does not crash all available workers. Default
#                             is no limit.
# -L, --listen=ADDRESS        Address the server should listen on. Default is
#                             INADDR_ANY.
# -p, --port=PORT             Port the server should listen on. Default=4730.
# -r, --protocol=PROTOCOL     Load protocol module.
# -t, --threads=THREADS       Number of I/O threads to use. Default=0.
# -v, --verbose               Increase verbosity level by one.
# -w, --worker-wakeup=WORKERS Number of workers to wakeup for each job received.
#                             The default is to wakeup all available workers.
GEARMAND_PARAMS=""
