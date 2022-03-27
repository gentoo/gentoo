# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-block/partimag"

ACCT_USER_HOME="/var/lib/partimage"
ACCT_USER_ID="91"
ACCT_USER_GROUPS=( "partimag" )

acct-user_add_deps
