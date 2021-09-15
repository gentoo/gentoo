# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dns/dnrd"

ACCT_USER_GROUPS=( "dnrd" )
ACCT_USER_ID="262"

acct-user_add_deps
