# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for cadvisor"
ACCT_USER_ID=427
ACCT_USER_GROUPS=( cadvisor )

acct-user_add_deps
