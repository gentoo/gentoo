# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for uptime daemon"
ACCT_USER_ID=220
ACCT_USER_GROUPS=( uptimed )

acct-user_add_deps
