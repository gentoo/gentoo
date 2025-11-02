# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for mail-filter/postsrsd"
ACCT_USER_ID=208
ACCT_USER_GROUPS=( postfix )

acct-user_add_deps
