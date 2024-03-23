# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-irc/psybnc"

ACCT_USER_GROUPS=( "psybnc" )
ACCT_USER_HOME="/var/lib/psybnc"
ACCT_USER_ID="259"

acct-user_add_deps
