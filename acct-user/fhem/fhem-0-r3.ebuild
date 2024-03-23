# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the FHEM perl server for house automation"

ACCT_USER_GROUPS=( "fhem" )
ACCT_USER_HOME="/opt/fhem"
ACCT_USER_ID="491"

acct-user_add_deps
