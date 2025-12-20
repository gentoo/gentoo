# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for dkimpy-milter"
ACCT_USER_ID=552
ACCT_USER_GROUPS=( dkimpy-milter )

acct-user_add_deps
