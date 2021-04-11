# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for www-servers/fnord"

ACCT_USER_GROUPS=( "nofiles" )
ACCT_USER_HOME="/etc/fnord"
ACCT_USER_ID="385"

acct-user_add_deps
