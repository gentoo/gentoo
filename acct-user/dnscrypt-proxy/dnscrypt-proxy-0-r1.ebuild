# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-dns/dnscrypt-proxy"
ACCT_USER_ID=353
ACCT_USER_GROUPS=( dnscrypt-proxy )

acct-user_add_deps
