# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for 3proxy"
ACCT_USER_ID=548
ACCT_USER_GROUPS=( 3proxy )

acct-user_add_deps
