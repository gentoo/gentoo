# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=169
ACCT_USER_GROUPS=( transmission )
ACCT_USER_HOME=/var/lib/transmission

acct-user_add_deps
