# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="MySQL program user"
ACCT_USER_ID=60
ACCT_USER_GROUPS=( mysql )
acct-user_add_deps
SLOT="0"
