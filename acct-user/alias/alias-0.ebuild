# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="alias user for qmail mail delivery"
ACCT_USER_ID=200
ACCT_USER_HOME=/var/qmail/alias
ACCT_USER_HOME_OWNER=alias:qmail
ACCT_USER_HOME_PERMS=02755
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
