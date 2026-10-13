# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Keydb program user"
ACCT_USER_ID=575
ACCT_USER_GROUPS=( keydb )
acct-user_add_deps
