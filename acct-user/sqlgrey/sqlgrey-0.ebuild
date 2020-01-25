# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for SQLGrey"

ACCT_USER_ID=336
ACCT_USER_GROUPS=( sqlgrey )
ACCT_USER_HOME="/var/spool/sqlgrey"

acct-user_add_deps
