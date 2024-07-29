# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=493
ACCT_USER_GROUPS=( oidentd )

acct-user_add_deps
