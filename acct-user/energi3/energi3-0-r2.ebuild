# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-p2p/energi3"
ACCT_USER_ID=218
ACCT_USER_GROUPS=( energi3 )

acct-user_add_deps
