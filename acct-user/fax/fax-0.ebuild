# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-dialup/mgetty"

ACCT_USER_GROUPS=( "fax" )
ACCT_USER_ID="320"

acct-user_add_deps
