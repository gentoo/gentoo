# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for package net-libs/tox"

ACCT_USER_ID=236 #day-month of first tox commit
ACCT_USER_GROUPS=( tox )

acct-user_add_deps
