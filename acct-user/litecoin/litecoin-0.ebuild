# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-p2p/litecoind"

ACCT_USER_GROUPS=( "litecoin" )
ACCT_USER_HOME="/var/lib/litecoin"
ACCT_USER_ID="256"

acct-user_add_deps
