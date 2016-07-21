# Agents startup file
#
# This file is sourced at Plasma startup, so that
# the environment variables set here are available
# throughout the session.
#
# Uncomment the following lines to start gpg-agent
# and/or ssh-agent at Plasma startup.
# If you do so, do not forget to uncomment the respective
# lines in PLASMADIR/shutdown/agent-shutdown.sh to
# properly kill the agents when the session ends.
#
# If using gpg-agent for ssh instead of ssh-agent, a GUI pinentry program
# must be selected either with eselect pinentry or adding an entry to
# $HOME/.gnupg/gpg-agent.conf such as "pinentry-program /usr/bin/pinentry-qt4".
#
# pinentry-curses or pinentry-tty will not work because the agent started here
# is in a different tty than where it is used, so the agent does not know where
# to request the passphrase and fails.

#GPG_AGENT=true
#SSH_AGENT=true
#SSH_AGENT=gpg # use gpg-agent for ssh instead of ssh-agent

if [ "${GPG_AGENT}" = true ]; then
	if [ -x /usr/bin/gpgconf ]; then
		gpgconf --launch gpg-agent >/dev/null 2>&1
		if [ $? = 2 ]; then
			eval "$(/usr/bin/gpg-agent --enable-ssh-support --daemon)"
		fi
	fi
fi

if [ "${SSH_AGENT}" = true ]; then
	if [ -x /usr/bin/ssh-agent ]; then
		eval "$(/usr/bin/ssh-agent -s)"
	fi
elif [ "${SSH_AGENT}" = gpg ] && [ "${GPG_AGENT}" = true ]; then
	if [ -e /run/user/$(id -ru)/gnupg/S.gpg-agent.ssh ]; then
		export SSH_AUTH_SOCK=/run/user/$(id -ru)/gnupg/S.gpg-agent.ssh
	elif [ -e "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
		export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
	fi
fi

# Uncomment the following lines to start rxvt-unicode which has the ability to
# run multiple terminals in one single process, thus starting up faster and
# saving resources.
# The --opendisplay ensures that the daemon quits when the X server terminates,
# therefore we don't need matching lines in agent-shutdown.sh.

#if [ -x /usr/bin/urxvtd ]; then
#	/usr/bin/urxvtd --opendisplay --fork --quiet
#fi
