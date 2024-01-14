# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for tvheadend"
ACCT_USER_ID=462
ACCT_USER_GROUPS=( video )
ACCT_USER_HOME=/var/lib/tvheadend
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
