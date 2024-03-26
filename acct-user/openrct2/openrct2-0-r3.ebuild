# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the OpenRCT2 dedicated server"

ACCT_USER_GROUPS=( "openrct2" )
ACCT_USER_ID="479"

acct-user_add_deps
