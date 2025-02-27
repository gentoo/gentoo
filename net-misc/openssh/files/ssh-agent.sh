# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License, v2 or later
#
if [ -f /run/openrc/softlevel ] && [ -z "$SSH_AUTH_SOCK" ]
		&& rc-service --user --exists ssh-agent 2>&1 >/dev/null; then
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.sock"
fi
