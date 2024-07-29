# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-misc/exabgp"

ACCT_USER_ID=316
ACCT_USER_GROUPS=( exabgp )

acct-user_add_deps
