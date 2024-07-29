# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-vpn/openvpn"

ACCT_USER_ID=394
ACCT_USER_GROUPS=( openvpn )

acct-user_add_deps
