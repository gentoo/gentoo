# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for graphite/carbon suite"
ACCT_USER_ID=230
ACCT_USER_GROUPS=( carbon )

acct-user_add_deps
