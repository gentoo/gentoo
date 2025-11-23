# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for pvpgn (gaming server for Battle.Net compatible clients)"
ACCT_USER_ID=285
ACCT_USER_GROUPS=( pvpgn )

acct-user_add_deps
