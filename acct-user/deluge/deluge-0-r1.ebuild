# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for deluge"
ACCT_USER_ID=454
ACCT_USER_GROUPS=( deluge )

acct-user_add_deps
