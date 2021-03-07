# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for www-apps/radicale"
ACCT_USER_ID=327
ACCT_USER_GROUPS=( radicale )

acct-user_add_deps
