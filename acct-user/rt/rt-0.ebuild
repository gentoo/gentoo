# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for www-apps/rt"

ACCT_USER_GROUPS=( "rt" )
ACCT_USER_ID="126"

acct-user_add_deps
