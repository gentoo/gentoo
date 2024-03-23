# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for etcd"
ACCT_USER_HOME=/var/lib/etcd
ACCT_USER_HOME_PERMS=700
ACCT_USER_ID=426
ACCT_USER_GROUPS=( etcd )

acct-user_add_deps
