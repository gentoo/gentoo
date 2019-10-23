# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Snapcast server component"
ACCT_USER_ID=114
ACCT_USER_HOME=/var/lib/snapserver
ACCT_USER_HOME_OWNER=snapserver:snapserver
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( snapserver )

acct-user_add_deps
