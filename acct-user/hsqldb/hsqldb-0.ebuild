# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for hsqldb"
ACCT_USER_ID=217
ACCT_USER_GROUPS=( hsqldb )

acct-user_add_deps
