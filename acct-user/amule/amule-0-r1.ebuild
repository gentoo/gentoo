# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-p2p/amule"
ACCT_USER_ID=468
ACCT_USER_GROUPS=( amule )

acct-user_add_deps
