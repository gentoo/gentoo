# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-misc/icecast"

ACCT_USER_GROUPS=( "icecast" )
ACCT_USER_ID="131"

acct-user_add_deps
