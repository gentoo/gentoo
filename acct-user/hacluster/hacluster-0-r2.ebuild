# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-cluster/cluster-glue"

ACCT_USER_GROUPS=( "haclient" )
ACCT_USER_HOME="/var/lib/heartbeat"
ACCT_USER_ID="304"

acct-user_add_deps
