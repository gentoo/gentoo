# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for app-misc/notary"

ACCT_USER_GROUPS=( "notary" )
ACCT_USER_ID="280"

acct-user_add_deps
