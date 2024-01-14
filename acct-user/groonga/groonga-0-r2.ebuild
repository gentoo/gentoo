# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-text/groonga"

ACCT_USER_GROUPS=( "groonga" )
ACCT_USER_ID="266"

acct-user_add_deps
