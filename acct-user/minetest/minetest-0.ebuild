# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Minetest server"

ACCT_USER_GROUPS=( "minetest" )
ACCT_USER_ID="480"

acct-user_add_deps
