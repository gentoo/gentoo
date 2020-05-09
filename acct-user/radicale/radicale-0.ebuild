# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="radicale program user"
ACCT_USER_ID=65
ACCT_USER_GROUPS=( radicale )
ACCT_USER_HOME=/var/lib/radicale
acct-user_add_deps
SLOT="0"
