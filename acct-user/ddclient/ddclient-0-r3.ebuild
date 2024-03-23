# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the dynamic DNS client"

ACCT_USER_GROUPS=( "ddclient" )
ACCT_USER_ID="487"

acct-user_add_deps
