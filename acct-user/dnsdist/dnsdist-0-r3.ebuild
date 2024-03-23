# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-dns/dnsdist"

ACCT_USER_GROUPS=( "dnsdist" )
ACCT_USER_ID="414"

acct-user_add_deps
