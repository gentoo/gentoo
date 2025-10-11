# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for onak"
ACCT_USER_ID=551
ACCT_USER_GROUPS=( onak )

acct-user_add_deps
