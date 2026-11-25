# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="net-wireless/kismet"
ACCT_USER_ID="388"
ACCT_USER_GROUPS=( kismet )

acct-user_add_deps
