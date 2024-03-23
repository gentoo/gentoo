# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="FreeRadius program user"
ACCT_USER_ID=95
ACCT_USER_GROUPS=( radius )
acct-user_add_deps
