# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for system-wide net-vpn/i2p"
ACCT_USER_ID=471
ACCT_USER_GROUPS=( i2p )
ACCT_USER_HOME=/var/lib/i2p

acct-user_add_deps
