# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-irc/rbot"

ACCT_USER_GROUPS=( "rbot" )
ACCT_USER_HOME="/var/lib/rbot"
ACCT_USER_ID="129"

acct-user_add_deps
