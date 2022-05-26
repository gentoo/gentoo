# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dns/dnsmasq"

ACCT_USER_ID=275
ACCT_USER_GROUPS=( dnsmasq )

acct-user_add_deps
