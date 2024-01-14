# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for biltbee"
ACCT_USER_ID=407
ACCT_USER_GROUPS=( bitlbee )

acct-user_add_deps
