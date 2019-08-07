# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=494
ACCT_USER_GROUPS=( unrealircd )

acct-user_add_deps
