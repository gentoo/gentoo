# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the dynamic DNS client"

ACCT_USER_GROUPS=( "ddclient" )
ACCT_USER_ID="487"

acct-user_add_deps
