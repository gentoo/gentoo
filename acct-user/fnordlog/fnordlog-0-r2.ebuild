# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-servers/fnord"

ACCT_USER_GROUPS=( "nofiles" )
ACCT_USER_HOME="/etc/fnord"
ACCT_USER_ID="385"

acct-user_add_deps
