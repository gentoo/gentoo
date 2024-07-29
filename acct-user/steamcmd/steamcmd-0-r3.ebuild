# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the SteamCMD server"

ACCT_USER_GROUPS=( "steamcmd" )
ACCT_USER_HOME="/opt/steamcmd"
ACCT_USER_ID="489"

acct-user_add_deps
