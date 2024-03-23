# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-devel/icecream"

ACCT_USER_GROUPS=( "icecream" )
ACCT_USER_HOME="/var/cache/icecream"
ACCT_USER_ID="145"

acct-user_add_deps
