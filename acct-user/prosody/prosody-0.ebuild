# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-im/prosody"

ACCT_USER_GROUPS=( "prosody" )
ACCT_USER_ID="115"

acct-user_add_deps
