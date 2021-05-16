# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-im/minbif"

ACCT_USER_GROUPS=( "minbif" )
ACCT_USER_HOME="/var/lib/minbif"
ACCT_USER_ID="260"

acct-user_add_deps
