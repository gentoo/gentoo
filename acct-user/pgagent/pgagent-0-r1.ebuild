# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="pgagent program user"
ACCT_USER_ID=135
ACCT_USER_SHELL=/bin/bash
ACCT_USER_HOME=/var/lib/pgagent
ACCT_USER_GROUPS=( pgagent )
acct-user_add_deps
SLOT="0"

pkg_postinst() {
	ewarn "The home directory has changed for pgagent."
	ewarn "You should move files, especially .pgpass, from:"
	ewarn "    /home/pgagent"
	ewarn "To:"
	ewarn "    ${ACCT_USER_HOME}"
}
