# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=0
ACCT_USER_ENFORCE_ID=yes
ACCT_USER_SHELL="/bin/bash"
ACCT_USER_HOME="/root"
ACCT_USER_HOME_PERMS=0700
ACCT_USER_GROUPS=( root )

# Avoid reverting changes by the sysadmin.
# https://bugs.gentoo.org/827813
ACCT_USER_NO_MODIFY=1

acct-user_add_deps

pkg_prerm() {
	# Don't lock out the superuser
	:
}
