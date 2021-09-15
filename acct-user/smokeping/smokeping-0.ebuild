# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-analyzer/smokeping"

ACCT_USER_GROUPS=( "smokeping" )
ACCT_USER_HOME="/var/lib/smokeping"
ACCT_USER_ID="164"

acct-user_add_deps
