# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for man page viewer"
ACCT_USER_ID=13
ACCT_USER_HOME=/usr/share/man
ACCT_USER_HOME_OWNER=root:root
ACCT_USER_GROUPS=( man )
ACCT_USER_SHELL=/bin/false

acct-user_add_deps
