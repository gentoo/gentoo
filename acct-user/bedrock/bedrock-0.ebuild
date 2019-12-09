# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Minecraft Bedrock server"

ACCT_USER_GROUPS=( "bedrock" )
ACCT_USER_ID="485"

acct-user_add_deps
