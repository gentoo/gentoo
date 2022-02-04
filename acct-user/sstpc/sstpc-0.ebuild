# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/sstp-client"

ACCT_USER_GROUPS=( "sstpc" )
ACCT_USER_ID="257"

acct-user_add_deps
