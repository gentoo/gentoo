# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=494
ACCT_USER_GROUPS=( unrealircd )

acct-user_add_deps
