# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-analyzer/rrdtool"

ACCT_USER_HOME="/var/lib/rrdcached"
ACCT_USER_ID="511"
ACCT_USER_GROUPS=( "rrdcached" )

acct-user_add_deps
