# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for games-simulation/openttd"

ACCT_USER_HOME="/var/lib/openttd"
ACCT_USER_GROUPS=( "openttd" )
ACCT_USER_ID="513"

acct-user_add_deps
