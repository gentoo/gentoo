# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=225
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
