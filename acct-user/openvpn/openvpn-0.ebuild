# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-vpn/openvpn"

ACCT_USER_ID=394
ACCT_USER_GROUPS=( openvpn )

acct-user_add_deps
