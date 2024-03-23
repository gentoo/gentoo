# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the CA NetConsole Daemon"

ACCT_USER_GROUPS=( "cancd" )
ACCT_USER_ID="213"

acct-user_add_deps
