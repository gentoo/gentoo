# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-dns/inadyn"

ACCT_USER_HOME="/var/lib/inadyn"
ACCT_USER_ID="529"
ACCT_USER_GROUPS=( "inadyn" )

acct-user_add_deps
