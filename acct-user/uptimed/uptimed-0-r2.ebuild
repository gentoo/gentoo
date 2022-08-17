# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for uptime daemon"

ACCT_USER_ID="220"
ACCT_USER_GROUPS=( "uptimed" )

acct-user_add_deps
