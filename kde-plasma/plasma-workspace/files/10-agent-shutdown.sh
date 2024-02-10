#!/bin/sh
#
# This file is executed at Plasma shutdown.
# Uncomment the following lines to kill the agents
# that were started at session startup.

# <gnupg-2.1.x
#if [ -n "${GPG_AGENT_INFO}" ]; then
#	kill $(echo ${GPG_AGENT_INFO} | cut -d':' -f 2) >/dev/null 2>&1
#fi

# >=gnupg-2.1.x
#gpgconf --kill gpg-agent >/dev/null 2>&1

#if [ -n "${SSH_AGENT_PID}" ]; then
#	eval "$(ssh-agent -s -k)"
#fi
