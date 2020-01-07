# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for pcsc-lite"
ACCT_USER_ID=47
ACCT_USER_GROUPS=( pcscd openct )

acct-user_add_deps
