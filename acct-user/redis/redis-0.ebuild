# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Redis program user"
ACCT_USER_ID=75
ACCT_USER_GROUPS=( redis )
acct-user_add_deps
