# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-p2p/bitflu"

ACCT_USER_GROUPS=( "bitflu" )
ACCT_USER_HOME="/var/lib/bitflu"
ACCT_USER_ID="148"

acct-user_add_deps
