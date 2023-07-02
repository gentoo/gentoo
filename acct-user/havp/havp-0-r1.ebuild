# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-proxy/havp"

ACCT_USER_GROUPS=( "havp" )
ACCT_USER_ID="254"

acct-user_add_deps
