# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-mail/mailgraph"
ACCT_USER_ID=376
ACCT_USER_GROUPS=( mgraph adm )
ACCT_USER_HOME="/var/lib/mailgraph"
ACCT_USER_HOME_PERMS=750

acct-user_add_deps
