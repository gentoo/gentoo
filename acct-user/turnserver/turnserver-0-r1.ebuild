# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for a turn server like coturn"

ACCT_USER_GROUPS=( "turnserver" )
ACCT_USER_ID="235"

acct-user_add_deps
