# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for dev-libs/openct"

ACCT_USER_GROUPS=( "openct" )
ACCT_USER_ID="46"

acct-user_add_deps
