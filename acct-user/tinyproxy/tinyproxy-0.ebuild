# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="uid for net-proxy/tinyproxy"
ACCT_USER_ID=186
ACCT_USER_GROUPS=( tinyproxy )

acct-user_add_deps
