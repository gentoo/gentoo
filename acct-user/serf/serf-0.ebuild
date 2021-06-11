# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for app-admin/serf"

ACCT_USER_HOME=/var/lib/serf
ACCT_USER_GROUPS=( "serf" )
ACCT_USER_ID="314"

acct-user_add_deps
