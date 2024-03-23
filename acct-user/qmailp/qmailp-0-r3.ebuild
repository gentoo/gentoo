# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for qmail-getpw"
ACCT_USER_ID=203
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
