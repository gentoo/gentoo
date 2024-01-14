# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-proxy/trojan"
ACCT_USER_ID=326
ACCT_USER_GROUPS=( trojan )

acct-user_add_deps
