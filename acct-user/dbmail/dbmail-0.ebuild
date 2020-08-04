# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for dbmail daemons"
ACCT_USER_ID=277
ACCT_USER_HOME="/var/lib/dbmail"
ACCT_USER_GROUPS=( dbmail mail )

acct-user_add_deps
