# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for telegraf"
ACCT_USER_ID=428
ACCT_USER_GROUPS=( telegraf )

acct-user_add_deps
