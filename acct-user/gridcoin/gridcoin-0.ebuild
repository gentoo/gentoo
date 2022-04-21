# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Gridcoin Research Wallet"
ACCT_USER_ID=512
ACCT_USER_GROUPS=( gridcoin )

acct-user_add_deps
