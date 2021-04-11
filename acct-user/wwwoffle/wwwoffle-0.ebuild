# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-proxy/wwwoffle"

ACCT_USER_GROUPS=( "wwwoffle" )
ACCT_USER_HOME="/var/spool/wwwoffle"
ACCT_USER_ID="251"

acct-user_add_deps
