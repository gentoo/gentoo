# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-misc/ices"

ACCT_USER_GROUPS=( "ices" )
ACCT_USER_ID="162"

acct-user_add_deps
