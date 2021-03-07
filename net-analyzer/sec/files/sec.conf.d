# configuration file for /etc/init.d/sec

# flags to pass to sec (see 'sec --help')
SEC_FLAGS=""

# Define a debug level (1..6)
DEBUG_LEVEL="4"

# define where sec reads messages from for translating them
#INPUT_FILES="${INPUT_FILES} -input=/var/log/some.log"
#INPUT_FILES="${INPUT_FILES} -input=/tmp/other.file"
INPUT_FILES="-input=/var/log/messages"
