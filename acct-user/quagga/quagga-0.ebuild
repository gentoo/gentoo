# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=425
ACCT_USER_GROUPS=( quagga )

acct-user_add_deps
