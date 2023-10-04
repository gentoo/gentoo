# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for slskd"
ACCT_USER_HOME=/var/lib/slskd
ACCT_USER_ID=532
ACCT_USER_GROUPS=( slskd )
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
