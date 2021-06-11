# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for sys-cluster/zookeeper-bin"

ACCT_USER_ID=217
ACCT_USER_GROUPS=( zookeeper )

acct-user_add_deps
