# Agents startup file
#
# This file is sourced at plasma startup, so that
# the environment variables set here are available
# throughout the session.

# Uncomment the following lines to start gpg-agent
# and/or ssh-agent at plasma startup.
# If you do so, do not forget to uncomment the respective
# lines in PLASMADIR/shutdown/agent-shutdown.sh to
# properly kill the agents when the session ends.

#if [ -x /usr/bin/gpg-agent ]; then
#  eval "$(/usr/bin/gpg-agent --daemon)"
#fi 

#if [ -x /usr/bin/ssh-agent ]; then
#  eval "$(/usr/bin/ssh-agent -s)"
#fi

# Uncomment the following lines to start rxvt-unicode which has the ability to
# run multiple terminals in one single process, thus starting up faster and 
# saving resources.
# The --opendisplay ensures that the daemon quits when the X server terminates,
# therefore we don't need matching lines in agent-shutdown.sh.

#if [ -x /usr/bin/urxvtd ]; then
#	/usr/bin/urxvtd --opendisplay --fork --quiet
#fi
