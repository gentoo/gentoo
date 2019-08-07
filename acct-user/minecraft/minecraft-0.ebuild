# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Minecraft server"

ACCT_USER_GROUPS=( "minecraft" )
ACCT_USER_HOME="/var/lib/minecraft-server"
ACCT_USER_ID="490"

acct-user_add_deps
