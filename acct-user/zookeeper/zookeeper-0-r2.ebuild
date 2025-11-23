# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-cluster/zookeeper-bin"

ACCT_USER_GROUPS=( "zookeeper" )
ACCT_USER_HOME="/var/lib/zookeeper"
ACCT_USER_ID="211"

acct-user_add_deps
