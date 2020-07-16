# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dns/dnscrypt-proxy"
ACCT_USER_ID=353
ACCT_USER_GROUPS=( dnscrypt-proxy )

acct-user_add_deps
