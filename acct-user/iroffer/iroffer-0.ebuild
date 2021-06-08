# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=187
ACCT_USER_GROUPS=( iroffer )

acct-user_add_deps
