# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for vnstat network monitoring"
ACCT_USER_ID=229
ACCT_USER_GROUPS=( vnstat )

acct-user_add_deps
