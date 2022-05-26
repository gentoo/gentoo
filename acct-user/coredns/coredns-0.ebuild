# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-dns/coredns"

ACCT_USER_HOME=/var/lib/coredns
ACCT_USER_GROUPS=( "coredns" )
ACCT_USER_ID="312"

acct-user_add_deps
