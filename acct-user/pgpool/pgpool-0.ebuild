# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for dev-db/pgpool2"

ACCT_USER_GROUPS=( "postgres" )
ACCT_USER_ID="106"

acct-user_add_deps
