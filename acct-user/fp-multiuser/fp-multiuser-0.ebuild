# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-vpn/fp-multiuser"

ACCT_USER_HOME=/var/lib/fp-multiuser
ACCT_USER_GROUPS=( "fp-multiuser" )
ACCT_USER_ID="318"

acct-user_add_deps
