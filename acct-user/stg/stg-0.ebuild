# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-misc/stargazer"

ACCT_USER_GROUPS=( "stg" )
ACCT_USER_ID="176"

acct-user_add_deps
