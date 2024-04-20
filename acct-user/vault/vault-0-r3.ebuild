# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for vault"
ACCT_USER_ID=410
ACCT_USER_GROUPS=( vault )

acct-user_add_deps
