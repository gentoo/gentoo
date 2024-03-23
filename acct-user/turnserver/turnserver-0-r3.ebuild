# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for a turn server like coturn"

ACCT_USER_GROUPS=( "turnserver" )
ACCT_USER_ID="235"

acct-user_add_deps
