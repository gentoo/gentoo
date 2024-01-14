# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the Minetest server"

ACCT_USER_GROUPS=( "minetest" )
ACCT_USER_ID="480"
ACCT_USER_HOME="/var/lib/minetest"

acct-user_add_deps
