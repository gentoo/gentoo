# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the TeamSpeak server"

ACCT_USER_GROUPS=( "teamspeak" )
ACCT_USER_HOME="/opt/teamspeak3-server"
ACCT_USER_ID="488"

acct-user_add_deps
