# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="PostgreSQL program user"
ACCT_USER_ID=70
ACCT_USER_GROUPS=( postgres )
ACCT_USER_HOME=/var/lib/postgresql
ACCT_USER_HOME_PERMS=0700
ACCT_USER_SHELL=/bin/sh
acct-user_add_deps
SLOT="0"
