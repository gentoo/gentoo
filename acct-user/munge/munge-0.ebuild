# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for sys-auth/munge"

ACCT_USER_GROUPS=( "munge" )
ACCT_USER_HOME="/var/lib/munge"
ACCT_USER_ID="144"

acct-user_add_deps
