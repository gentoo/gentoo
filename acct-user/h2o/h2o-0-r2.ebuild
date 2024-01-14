# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for www-servers/h2o"

ACCT_USER_GROUPS=( "h2o" )
ACCT_USER_ID="141"

acct-user_add_deps
