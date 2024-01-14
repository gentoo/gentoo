# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="PgBouncer program user"
ACCT_USER_ID=463
ACCT_USER_GROUPS=( postgres )
acct-user_add_deps
SLOT="0"
