# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=0
ACCT_USER_ENFORCE_ID=yes
ACCT_USER_SHELL="/bin/bash"
ACCT_USER_HOME="/root"
ACCT_USER_HOME_PERMS=0700
ACCT_USER_GROUPS=( root )

acct-user_add_deps

pkg_prerm() {
	# Don't lock out the superuser
	:
}
