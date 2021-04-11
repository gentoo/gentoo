# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/rwhoisd"

ACCT_USER_GROUPS=( "rwhoisd" )
ACCT_USER_HOME="/var/rwhoisd"
ACCT_USER_ID="258"

acct-user_add_deps
